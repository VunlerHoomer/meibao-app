//
//  MeibaoApp.swift
//  MeibaoApp
//
//  App 入口：TabView 导航（每个 Tab 各自包一层 NavigationStack）
//

import SwiftUI

@main
struct MeibaoApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    HomeView()
                }
                .tabItem { Label("Home", systemImage: "house") }

                NavigationStack {
                    CheckView(school: MockDataService.sampleSchools.first ?? School(id: UUID(), name: "UCSD", state: "CA", portalHint: "AHP"))
                }
                .tabItem { Label("Check", systemImage: "checkmark.seal") }

                NavigationStack {
                    ResultView(result: MockDataService.sampleResultPass)
                }
                .tabItem { Label("Result", systemImage: "doc.text.magnifyingglass") }

                NavigationStack {
                    PackageView()
                }
                .tabItem { Label("Package", systemImage: "shippingbox") }

                NavigationStack {
                    SettingsView()
                }
                .tabItem { Label("Settings", systemImage: "gearshape") }
            }
        }
    }
}

