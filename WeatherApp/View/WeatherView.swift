import SwiftUI

struct WeatherView: View {
    @State private var temperature = "Loading..." // 初期値を設定
    @State private var errorMessage: String? // エラーメッセージ用の変数

    func getWeather() async {
        let result = await APIClient().request(
            item: GetWeatherForecastRequest(
                parameters: .init(q: "Tokyo")
            )
        )
        switch result {
        case let .success(response):
            DispatchQueue.main.async {
                self.temperature = "\(response.list.first?.main.temp ?? 0)°C"
                self.errorMessage = nil
            }
        case let .failure(error):
            DispatchQueue.main.async {
                self.errorMessage = error.errorDescription
                self.temperature = "Error"
            }
        }
    }

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(temperature) // 温度を表示
                .font(.largeTitle)
                .padding()

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .task {
            await getWeather() // Viewがロードされたときに天気情報を取得
        }
    }
}

#Preview {
    WeatherView()
}
