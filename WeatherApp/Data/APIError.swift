import Foundation

public enum APIError: LocalizedError, Equatable {
    case unknown
    case responseError(Int)
    case decodeError(String)
}
