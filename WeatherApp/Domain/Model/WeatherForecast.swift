import Foundation

struct WeatherForecast: Codable, Hashable {
    let date: String
    let temp: Double
    let iconUrl: String
}
