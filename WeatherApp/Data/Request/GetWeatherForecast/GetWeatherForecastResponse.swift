import Foundation

struct GetWeatherForecastResponse: Codable {
    let message: Int
    let list: [Info]

    struct Info: Codable {
        let dt: Int // 予測データの時刻
        let main: Main

        struct Main: Codable {
            let temp: Double // 気温
        }

        struct Wether: Codable {
            let icon: String // 天気アイコンID
        }
    }
}
