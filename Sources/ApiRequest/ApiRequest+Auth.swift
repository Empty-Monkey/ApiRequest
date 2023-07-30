import Foundation

extension ApiRequest {
    @discardableResult
    public func withBearerToken(_ token: String) -> Self {
        return self.withHeader("Bearer \(token)", header: .authorization)
    }
}
