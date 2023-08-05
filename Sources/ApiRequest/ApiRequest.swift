import Foundation

open class ApiRequest {
    public var request: URLRequest
    private var url: URL
    
    /// ApiRequestError
    public enum ApiRequestError: Error {
        case invalidUrl
    }
    
    
    /// Init ApiRequest with URL
    ///
    /// - Parameter url: URL to send the requests to as a string.
    public init?(_ url: String) {
        guard let url = URL(string: url) else {
            return nil
        }
        
        self.url = url
        self.request = URLRequest(url: self.url)
        self.withHeader("ApiRequest/Swift (iOS)", header: .userAgent)
    }
    
    
    @discardableResult
    /// Add header to the request
    /// - Parameters:
    ///   - value: Value for the header
    ///   - header: Name of the header as `HTTPHeader`
    /// - Returns: Returns `ApiRequest` with the new header
    public func withHeader(_ value: String?, header: HTTPHeader) -> Self {
        self.request.setValue(value, forHTTPHeaderField: header.rawValue)
        
        return self
    }
    
    @discardableResult
    /// Add header to the request
    /// - Parameters:
    ///   - value: Value for the header
    ///   - header: Name of the header as `String`
    /// - Returns: Returns `ApiRequest` with the new header
    public func withHeader(_ value: String?, header: String) -> Self {
        self.request.setValue(value, forHTTPHeaderField: header)
        
        return self
    }
    
    @discardableResult
    /// Adds a new value to a header
    /// - Parameters:
    ///   - value: Added value for the header
    ///   - header: Name of the header as `HTTPHeader`
    /// - Returns: Returns `ApiRequest` with the new header value added to the header
    public func withAddedHeader(_ value: String, header: HTTPHeader) -> Self {
        self.request.addValue(value, forHTTPHeaderField: header.rawValue)
        
        return self
    }
    
    @discardableResult
    /// Adds a new value to a header
    /// - Parameters:
    ///   - value: Added value for the header
    ///   - header: Name of the header as `String`
    /// - Returns: Returns `ApiRequest` with the new header value added to the header
    public func withAddedHeader(_ value: String, header: String) -> Self {
        self.request.addValue(value, forHTTPHeaderField: header)
        
        return self
    }
    
    @discardableResult
    /// Add header `Content-type` to the request
    /// - Parameter contentType: Value for the `Content-type` header
    /// - Returns: Returns `ApiRequest` with the `Content-type` header
    public func withContentType(_ contentType: String) -> Self {
        self.request.setValue(contentType, forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        
        return self
    }
    
    @discardableResult
    /// Add header `Accept` to the request
    /// - Parameter acceptType: Value for the `Accept` header
    /// - Returns: Returns `ApiRequest` with the `Accept` header
    public func withHeaderAccept(_ acceptType: String) -> Self {
        self.request.setValue(acceptType, forHTTPHeaderField: HTTPHeader.accept.rawValue)
        
        return self
    }
    
    @discardableResult
    /// Add body to the request
    /// - Parameter body: Body defined as a `String`
    /// - Returns: Returns `ApiRequest` with the new body
    public func withBody(_ body: String) -> Self {
        self.request.httpBody = body.data(using: .utf8)
        
        return self
    }
    
    @discardableResult
    /// Add JSON body to the request using encodable data
    ///
    /// This also sets the header `Content-type` to match JSON payload.
    /// 
    /// - Parameter data: Data to be encoded to JSON string value to body
    /// - Returns: Returns `ApiRequest` with the new JSON body
    public func withJsonBody(_ data: Encodable) -> Self {
        let encoder = JSONEncoder()
        
        #if DEBUG
        encoder.outputFormatting = .prettyPrinted
        #endif
        
        var jsonString: String = ""
        
        do {
            let jsonData = try encoder.encode(data)
            jsonString = String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            print("Error encoding object to JSON: \(error)")
            
            return self
        }
        
        self.withContentType(HTTPContentType.json.rawValue)
        self.request.httpBody = jsonString.data(using: .utf8)
        
        return self
    }
    
    /// Send the request to the defined URL
    /// - Parameters:
    ///   - method: Defines the HTTP method to use for sending the request, such as GET or POST. Uses `HTTPMethod` to define the value.
    ///   - completionHandler: Function for handling the response or error from sending the request.
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
    
    /// Check if method supports body for the request
    /// - Parameter method: Method to check for using `HTTPMethod`.
    /// - Returns: Returns `Bool` value `true` if the method supports body, `false` otherwise.
    private func httpMethodSupportsBody(_ method: HTTPMethod) -> Bool {
        let methodsWithBody: Set<HTTPMethod> = [.post, .put, .patch, .delete]
        
        return methodsWithBody.contains(method)
    }
}
