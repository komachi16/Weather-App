struct ForecastRepository: Repository {
    // 天気予報取得
    static func getWeatherForecast(
        parameter: GetWeatherForecastRequest.Parameters
    ) async -> Result<GetWeatherForecastRequest.Response, APIError> {
        await execute(request: GetWeatherForecastRequest(parameters: parameter))
    }
}
