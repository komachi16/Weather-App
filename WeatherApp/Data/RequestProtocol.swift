import Foundation

public protocol RequestProtocol {
    associatedtype Response: Decodable
    associatedtype Parameters: Encodable

    var headers: [String: String] { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var baseURL: String { get }
    var path: String { get }
    var successHandler: (Response) -> Void { get }
    var failureHandler: (Error) -> Void { get }

    init(
        parameters: Parameters
    )
}

extension RequestProtocol {
    var queryItems: [URLQueryItem]? {
        var query: [URLQueryItem] = []

        if let p = parameters as? [Encodable] {
            query = p.flatMap { param in
                param.toDictionary().map { key, value in
                    URLQueryItem(name: key, value: value?.description ?? "")
                }
            }
        } else {
            parameters.toDictionary().forEach { key, value in
                if let array = value as? [String] {
                    array.forEach {
                        query.append(URLQueryItem(name: key, value: $0))
                    }
                } else {
                    query.append(URLQueryItem(name: key, value: value?.description ?? ""))
                }
            }
        }
        return query.sorted { first, second -> Bool in
            first.name > second.name
        }
    }

    var body: Data? {
        guard method != .get else { return nil }
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return try? jsonEncoder.encode(parameters)
    }

    var successHandler: (Response) -> Void {{ _ in }}

    var failureHandler: (Error) -> Void {{ _ in }}
}

private extension Encodable {
    func toDictionary() -> [String: CustomStringConvertible?] {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return (
            try? JSONSerialization.jsonObject(with: jsonEncoder.encode(self))
        ) as? [String: CustomStringConvertible?] ?? [:]
    }
}
