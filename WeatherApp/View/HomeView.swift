import CoreLocation
import SwiftUI

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()

    var regions: [Region] {
        Region.allRegions
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(regions, id: \.self) { region in
                        NavigationLink {
                            WeatherView(region: region)
                        } label: {
                            Text(region.name)
                        }
                    }

                    NavigationLink(
                        destination: locationManager.location != nil
                            ?
                            AnyView(WeatherView(region: .current(
                                location: locationManager
                                    .location!
                            )))
                            : AnyView(EmptyView()),
                        isActive: .constant(locationManager.location != nil)
                    ) {
                        Text("現在地を表示")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("地域を選択")
        }
    }
}

#Preview {
    HomeView()
}
