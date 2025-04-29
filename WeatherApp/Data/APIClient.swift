import Foundation

struct APIClient {
    func request<T: RequestProtocol>(
        item: T,
    ) async -> Result<T.Response, APIError> {
        await withCheckedContinuation { continuation in
            request(item: item) { result in
                continuation.resume(returning: result)
            }
        }
    }

    private func request<R: RequestProtocol, T>(
        item: R,
        completion: @escaping (Result<T, APIError>) -> Void
    ) where R.Response == T {
        guard let urlRequest = createURLRequest(item) else {
            return completion(.failure(.unknown))
        }

        let currentDate = Date()

        // キャッシュは同日のみ有効にする
        if let cache = URLCache.shared.cachedResponse(for: urlRequest) {
            // 現在の日付を日本時間で取得
            let currentDate = Date()
            let japanTimeZone = TimeZone(identifier: "Asia/Tokyo")!
            var calendar = Calendar.current
            calendar.timeZone = japanTimeZone

            // キャッシュの取得日を取得
            if let cachedDate = cache.userInfo?["date"] as? Date {
                // 日本時間で同じ日かどうかをチェック
                if calendar.isDate(currentDate, inSameDayAs: cachedDate) {
                    decode(data: cache.data, completion: completion)
                    return
                }
            }
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let nsError = error as NSError? {
                return completion(.failure(.responseError(nsError.code)))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.unknown))
            }

            guard (200 ... 299).contains(httpResponse.statusCode) else {
                return completion(.failure(.responseError(httpResponse.statusCode)))
            }

            guard let data = data else {
                return completion(.failure(.unknown))
            }

            let cachedResponse = CachedURLResponse(
                response: httpResponse,
                data: data,
                userInfo: ["date": currentDate],
                storagePolicy: .allowed
            )
            URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)

            decode(data: data, completion: completion)
        }

        task.resume()
    }

    private func createURLRequest<R: RequestProtocol>(_ requestItem: R) -> URLRequest? {
        guard let fullPath = URL(string: requestItem.baseURL + requestItem.path) else { return nil }

        var urlComponents = URLComponents()

        urlComponents.scheme = fullPath.scheme
        urlComponents.host = fullPath.host
        urlComponents.path = fullPath.path
        urlComponents.port = fullPath.port
        urlComponents.queryItems = requestItem.queryItems

        guard let url = urlComponents.url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestItem.method.rawValue
        urlRequest.httpBody = requestItem.body
        urlRequest.timeoutInterval = 20.0

        requestItem.headers.forEach { urlRequest.addValue($1, forHTTPHeaderField: $0) }

        return urlRequest
    }

    private func decode<T: Decodable>(
        data: Data,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let value = try jsonDecoder.decode(T.self, from: data)
            completion(.success(value))
        } catch {
            completion(.failure(.decodeError(error.localizedDescription)))
        }
    }
}
