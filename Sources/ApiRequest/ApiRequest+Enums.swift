extension ApiRequest {
    /// An enum defining supported HTTP methods
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case head = "HEAD"
        case options = "OPTIONS"
        case connect = "CONNECT"
    }

    /// An enum containting some of the most common content types for HTTP requests
    public enum HTTPContentType: String {
        case json = "application/json"
        case xml = "application/xml"
        case html = "text/html"
        case plainText = "text/plain"
        case formData = "application/x-www-form-urlencoded"
        case multipartFormData = "multipart/form-data"
        case octetStream = "application/octet-stream"
        case pdf = "application/pdf"
        case pngImage = "image/png"
        case jpegImage = "image/jpeg"
        case gifImage = "image/gif"
    }
    
    /// An enum containing some of the most commonly used headers
    public enum HTTPHeader: String {
        case accept = "Accept"
        case acceptCharset = "Accept-Charset"
        case acceptEncoding = "Accept-Encoding"
        case acceptLanguage = "Accept-Language"
        case authorization = "Authorization"
        case cacheControl = "Cache-Control"
        case contentType = "Content-Type"
        case cookie = "Cookie"
        case userAgent = "User-Agent"
        case contentLength = "Content-Length"
        case contentEncoding = "Content-Encoding"
        case contentLanguage = "Content-Language"
        case contentDisposition = "Content-Disposition"
        case connection = "Connection"
        case host = "Host"
        case referer = "Referer"
        case origin = "Origin"
        case upgrade = "Upgrade"
        case etag = "ETag"
        case ifMatch = "If-Match"
        case ifNoneMatch = "If-None-Match"
        case ifModifiedSince = "If-Modified-Since"
        case ifUnmodifiedSince = "If-Unmodified-Since"
        case range = "Range"
    }
}
