//
//  WeatherApp.swift
//  WeatherApp

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationManager)
        }
    }
}
