import CoreLocation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var selectedRegion: Region?

    var regions: [Region] {
        Region.allRegions
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(regions, id: \.self) { region in
                        NavigationLink(value: region) {
                            Text(region.name)
                        }
                    }

                    if let location = locationManager.location {
                        NavigationLink(value: location) {
                            HStack {
                                Text("現在地を表示")
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                        }
                    } else {
                        Button {
                            locationManager.requestPermission()
                        } label: {
                            HStack {
                                Text("位置情報を取得")
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("地域を選択")
            .navigationDestination(for: Region.self) { region in
                WeatherView(region: region)
            }
            .navigationDestination(for: CLLocation.self) { location in
                WeatherView(region: .current(location: location))
            }
        }
    }
}

#Preview {
    let locationManager = LocationManager()
    locationManager.location = CLLocation(
        latitude: 35.70206900,
        longitude: 139.77532690
    )
    return HomeView()
        .environmentObject(locationManager)
}
