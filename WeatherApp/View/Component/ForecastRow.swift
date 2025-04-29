import SwiftUI

struct ForecastRow: View {
    var forecast: WeatherForecast

    var body: some View {
        HStack {
            ImageView(imageUrl: forecast.iconUrl)
                .frame(width: 40, height: 40)
                .padding(.trailing, 16)

            VStack(alignment: .leading) {
                // 小数点第1位まで表示する
                Text("\(String(format: "%.1f", forecast.temp))°C")
                    .font(.headline)
                Text("\(forecast.date)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ForecastRow(
        forecast: .init(
            date: "2025-04-28 18:00:00",
            temp: 19.28,
            iconUrl: "https://openweathermap.org/img/wn/10d@2x.png"
        )
    )
}
