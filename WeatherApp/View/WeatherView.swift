import SwiftUI

struct WeatherView: View {
    @State private var forecasts: [GetWeatherForecastResponse.Info] = []
    @State private var errorMessage: String?
    @State private var showAlert = false
    var region: Region

    init(region: Region) {
        self.region = region
    }

    func getWeather() async {
        let result = await ForecastRepository.getWeatherForecast(
            parameter: .init(q: region.code)
        )
        switch result {
        case let .success(response):
            DispatchQueue.main.async {
                self.forecasts = response.list
                self.errorMessage = nil
            }
        case let .failure(error):
            DispatchQueue.main.async {
                self.errorMessage = error.errorDescription
                self.showAlert = true
                self.forecasts = []
            }
        }
    }

    var body: some View {
        VStack {
            List(forecasts, id: \.dt) { forecast in
                HStack {
                    Image(systemName: "cloud")
                    VStack(alignment: .leading) {
                        Text("\(forecast.main.temp)°C")
                        Text("\(forecast.dt)")
                    }
                }
            }
        }
        .padding()
        .task {
            await getWeather() // Viewがロードされたときに天気情報を取得
        }
        .navigationTitle(region.name)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("エラー"),
                message: Text(errorMessage ?? "不明なエラーが発生しました。"),
                primaryButton: .default(Text("リトライ")) {
                    Task {
                        await getWeather()
                    }
                },
                secondaryButton: .cancel(Text("戻る")) {
                    // 戻るボタンが押された場合の処理
                }
            )
        }
    }
}

#Preview {
    WeatherView(region: .tokyo)
}
