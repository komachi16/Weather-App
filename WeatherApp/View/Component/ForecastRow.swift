import SwiftUI

struct ForecastRow: View {
    var forecast: WeatherForecast

    var body: some View {
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

#Preview {
    ForecastRow(
        forecast: .init(
            date: "2025",
            temp: 19.28,
            iconUrl: "https://openweathermap.org/img/wn/10d@2x.png"
        )
    )
}
