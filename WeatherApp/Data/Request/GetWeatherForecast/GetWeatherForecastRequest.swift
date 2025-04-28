import Foundation

final class GetWeatherForecastRequest: RequestProtocol {
    typealias Response = GetWeatherForecastResponse

    struct Parameters: Encodable {
        let q: String // 都市名
        let appid: String? = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String // APIキー
        let units = "metric" // 測定単位
        let lang = "ja"
    }

    let parameters: Parameters

    var headers: [String: String] {
        [:]
    }

    var method: HTTPMethod {
        .get
    }

    var baseURL: String { "https://api.openweathermap.org" }

    var path: String { "/data/2.5/forecast" }

    init(
        parameters: Parameters
    ) {
        self.parameters = parameters
    }
}
