import Foundation

extension ApiRequest {
    @discardableResult
    /// Add header `Authorization` with the token prepended with `Bearer `.
    ///
    /// For example, providing token `xyz` will add a header `Authorization: Bearer xyz`.
    /// - Parameter token: The bearer token to be added as to the header.
    /// - Returns: Returns `ApiRequest` with the `Authorization` header.
    public func withBearerToken(_ token: String) -> Self {
        return self.withHeader("Bearer \(token)", header: .authorization)
    }
}
