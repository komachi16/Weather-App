import CoreLocation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var selectedRegion: Region?
    @State private var showLocationPermissionAlert = false

    var regions: [Region] {
        Region.allRegions
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    fixedRegionLinks
                    currentLocationLink
                }
            }
            .navigationTitle("地域を選択")
            .navigationDestination(for: Region.self) { region in
                WeatherView(region: region)
            }
            .navigationDestination(for: CLLocation.self) { location in
                WeatherView(region: .current(location: location))
            }
            .alert(isPresented: $showLocationPermissionAlert) {
                Alert(
                    title: Text("位置情報サービスを\nオンにして下さい"),
                    message: Text("「設定」アプリ ⇒「プライバシー」⇒「位置情報サービス」からオンにできます"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // 4つの固定リージョンの天気予報へのリンク
    private var fixedRegionLinks: some View {
        ForEach(regions, id: \.self) { region in
            NavigationLink(value: region) {
                Text(region.name)
            }
        }
    }

    // 現在地の天気予報へのリンク または 位置情報取得ボタン
    private var currentLocationLink: some View {
        Group {
            if let location = locationManager.location {
                NavigationLink(value: location) {
                    HStack {
                        Text("現在地を表示")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                }
            } else {
                NavigationLink(destination: EmptyView()) {
                    HStack {
                        Text("位置情報を取得")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                }
                .onTapGesture {
                    if locationManager.authorizationStatus == .notDetermined {
                        locationManager.requestPermission()
                    } else {
                        showLocationPermissionAlert = true
                    }
                }
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
