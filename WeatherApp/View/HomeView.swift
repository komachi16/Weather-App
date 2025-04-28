//
//  HomeView.swift
//  WeatherApp

import SwiftUI

struct HomeView: View {
    var regions: [Region] {
        Region.allCases
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(regions, id: \.self) { region in
                    NavigationLink {
                        WeatherView(region: region)
                    } label: {
                        Text(region.name)
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
