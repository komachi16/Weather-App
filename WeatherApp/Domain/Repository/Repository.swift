import Combine

protocol Repository {
    static func execute<R: RequestProtocol>(request: R) async -> Result<R.Response, APIError>
}

extension Repository {
    static func execute<R: RequestProtocol>(request: R) async -> Result<R.Response, APIError> {
        let result = await APIClient().request(item: request)

        switch result {
        case let .success(value):
            request.successHandler(value)

        case let .failure(error):
            request.failureHandler(error)
        }

        return result
    }
}
