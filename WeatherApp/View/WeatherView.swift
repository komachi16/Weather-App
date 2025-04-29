import SwiftUI

struct WeatherView: View {
    @State private var forecasts: [WeatherForecast] = []
    @State private var errorMessage: String?
    @State private var showAlert = false
    var region: Region
    @Environment(\.presentationMode) var presentationMode

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
                self.forecasts = response
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
        forecastListView
            .padding()
            .task {
                await getWeather() // Viewがロードされたときに天気情報を取得
            }
            .navigationTitle(region.name)
            .alert(isPresented: $showAlert) {
                errorAlert
            }
    }

    private var forecastListView: some View {
        List(forecasts, id: \.date) { forecast in
            ForecastRow(forecast: forecast)
        }
    }

    private var errorAlert: Alert {
        Alert(
            title: Text("エラー"),
            message: Text(errorMessage ?? "不明なエラーが発生しました。"),
            primaryButton: .default(Text("リトライ")) {
                Task {
                    await getWeather()
                }
            },
            secondaryButton: .cancel(Text("戻る")) {
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}

#Preview {
    WeatherView(region: .tokyo)
}
