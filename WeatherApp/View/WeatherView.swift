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
        VStack {
            List(forecasts, id: \.date) { forecast in
                HStack {
                    ImageView(imageUrl: forecast.iconUrl)
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 16)

                    VStack(alignment: .leading) {
                        Text("\(forecast.temp)°C")
                            .font(.headline)
                        Text("\(forecast.date)")
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 4)
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
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    WeatherView(region: .tokyo)
}
