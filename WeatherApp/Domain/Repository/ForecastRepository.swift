struct ForecastRepository: Repository {
    // 天気予報取得
    static func getWeatherForecast(
        parameter: GetWeatherForecastRequest.Parameters
    ) async -> Result<[WeatherForecast], APIError> {
        let result = await execute(request: GetWeatherForecastRequest(parameters: parameter))

        switch result {
        case let .success(response):
            let weatherForecast = mapToWeatherForecast(response)
            return .success(weatherForecast)

        case let .failure(error):
            return .failure(error)
        }
    }

    private static func mapToWeatherForecast(
        _ response: GetWeatherForecastRequest.Response
    ) -> [WeatherForecast] {
        return response.list.map {
            WeatherForecast(
                date: $0.dt.convertToJstDateString(),
                temp: $0.main.temp,
                iconUrl: convertToIconUrlString(iconId: $0.weather.first?.icon)
            )
        }
    }

    private static func convertToIconUrlString(iconId: String?) -> String {
        guard let iconId else {
            return ""
        }
        return "https://openweathermap.org/img/wn/\(iconId)@2x.png"
    }
}
