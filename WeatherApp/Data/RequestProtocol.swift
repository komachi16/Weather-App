import Foundation

/// `RequestProtocol` は、HTTPリクエストの基本的な構造を定義する
public protocol RequestProtocol {
    /// レスポンスの型
    associatedtype Response: Decodable

    /// パラメータの型
    associatedtype Parameters: Encodable

    /// リクエストヘッダー
    var headers: [String: String] { get }

    /// HTTPメソッド
    var method: HTTPMethod { get }

    /// リクエストパラメータ
    var parameters: Parameters { get }

    /// クエリアイテム
    var queryItems: [URLQueryItem]? { get }

    /// リクエストボディ
    var body: Data? { get }

    /// ベースURL
    var baseURL: String { get }

    /// エンドポイントのパス
    var path: String { get }

    /// 成功時のハンドラー
    var successHandler: (Response) -> Void { get }

    /// 失敗時のハンドラー
    var failureHandler: (Error) -> Void { get }

    /// イニシャライザ
    /// - Parameter parameters: リクエストに必要なパラメータ
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
