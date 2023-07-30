import Foundation

public class ApiRequest {
    private var request: URLRequest
    private var url: URL
    
    public enum ApiRequestError: Error {
        case invalidUrl
    }
    
    public init?(_ url: String) {
        guard let url = URL(string: url) else {
            return nil
        }
        
        self.url = url
        self.request = URLRequest(url: self.url)
        self.withHeader("ApiRequest/Swift (iOS)", header: .userAgent)
    }
    
    @discardableResult
    public func withHeader(_ value: String?, header: HTTPHeader) -> Self {
        self.request.setValue(value, forHTTPHeaderField: header.rawValue)
        
        return self
    }
    
    @discardableResult
    public func withHeader(_ value: String?, header: String) -> Self {
        self.request.setValue(value, forHTTPHeaderField: header)
        
        return self
    }
    
    @discardableResult
    public func withAddedHeader(_ value: String, header: HTTPHeader) -> Self {
        self.request.addValue(value, forHTTPHeaderField: header.rawValue)
        
        return self
    }
    
    @discardableResult
    public func withAddedHeader(_ value: String, header: String) -> Self {
        self.request.addValue(value, forHTTPHeaderField: header)
        
        return self
    }
    
    @discardableResult
    public func withContentType(_ contentType: String) -> Self {
        self.request.setValue(contentType, forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        
        return self
    }
    
    @discardableResult
    public func withHeaderAccept(_ acceptType: String) -> Self {
        self.request.setValue(acceptType, forHTTPHeaderField: HTTPHeader.accept.rawValue)
        
        return self
    }
    
    @discardableResult
    public func withBody(_ body: String) -> Self {
        self.request.httpBody = body.data(using: .utf8)
        
        return self
    }
    
    public func get(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.send(method: HTTPMethod.get, completionHandler: completionHandler)
    }
    
    public func post(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.send(method: HTTPMethod.post, completionHandler: completionHandler)
    }
    
    public func put(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.send(method: HTTPMethod.put, completionHandler: completionHandler)
    }

    public func patch(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.send(method: HTTPMethod.patch, completionHandler: completionHandler)
    }

    public func delete(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.send(method: HTTPMethod.delete, completionHandler: completionHandler)
    }
    
    public func head(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.send(method: HTTPMethod.head, completionHandler: completionHandler)
    }

    public func options(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.send(method: HTTPMethod.options, completionHandler: completionHandler)
    }
    
    public func connect(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.send(method: HTTPMethod.connect, completionHandler: completionHandler)
    }
}

extension ApiRequest {
    private func send(method: HTTPMethod, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.request.httpMethod = method.rawValue
        
        if (self.httpMethodSupportsBody(method)) {
            self.request.setValue(String(self.request.httpBody?.count ?? 0), forHTTPHeaderField: HTTPHeader.contentLength.rawValue)
        }
        
        let task = URLSession.shared.dataTask(with: self.request) { data, response, error in
            completionHandler(data, response, error)
        }
        
        task.resume()
    }
    
    private func httpMethodSupportsBody(_ method: HTTPMethod) -> Bool {
        let methodsWithBody: Set<HTTPMethod> = [.post, .put, .patch, .delete]
        
        return methodsWithBody.contains(method)
    }
}
