import Foundation

struct WeatherForecast: Codable, Hashable {
    let dt: Int
    let temp: Double
    let weather: [Weather]

    struct Weather: Codable, Hashable {
        let icon: String
    }
}
