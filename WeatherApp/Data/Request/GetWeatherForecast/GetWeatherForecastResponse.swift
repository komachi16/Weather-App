import Foundation

struct GetWeatherForecastResponse: Codable {
    let message: Int
    let list: [Info]

    struct Info: Codable {
        let dt: Int // 予測データの時刻
        let main: Main
        let weather: [Weather]

        struct Main: Codable {
            let temp: Double // 気温
        }

        struct Weather: Codable {
            let icon: String // 天気アイコンID
        }
    }
}
