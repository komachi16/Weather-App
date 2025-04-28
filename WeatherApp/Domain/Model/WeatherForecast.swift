import Foundation

struct WeatherForecast: Codable, Hashable {
    let date: String
    let temp: Double
    let weather: [Weather]

    struct Weather: Codable, Hashable {
        let icon: String
    }
}
