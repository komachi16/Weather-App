import Foundation

public protocol RequestProtocol {
    associatedtype Response: Decodable
    associatedtype Parameters: Encodable
    associatedtype PathComponent

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
        parameters: Parameters,
        pathComponent: PathComponent
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
