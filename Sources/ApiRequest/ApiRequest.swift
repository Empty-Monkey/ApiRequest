import Foundation

open class ApiRequest {
    public var request: URLRequest
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
    
    @discardableResult
    public func withBody(_ body: Encodable) -> Self {
        let encoder = JSONEncoder()
        
        #if DEBUG
        encoder.outputFormatting = .prettyPrinted
        #endif
        
        var jsonString: String = ""
        
        do {
            let jsonData = try encoder.encode(body)
            jsonString = String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            print("Error encoding object to JSON: \(error)")
            
            return self
        }
        
        self.request.httpBody = jsonString.data(using: .utf8)
        
        return self
    }
    
    public func send(_ method: HTTPMethod, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
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
