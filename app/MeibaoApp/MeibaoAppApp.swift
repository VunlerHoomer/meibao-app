import SwiftUI

@main
struct MeibaoApp: App {
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            TabView(selection: $router.selectedTab) {
                // Home
                NavigationStack {
                    HomeView()
                }
                .tabItem { Label("Home", systemImage: "house") }
                .tag(AppRouter.Tab.home)

                // Check 
                NavigationStack {
                    CheckView(
                        school: router.selectedSchool
                          ?? School(id: UUID(), name: "UCSD", state: "CA", portalHint: "AHP")
                    )
                }
                .tabItem { Label("Check", systemImage: "checkmark.seal") }
                .tag(AppRouter.Tab.check)

                // Result
                NavigationStack {
                    ResultView(result: router.latestResult ?? MockDataService.sampleResultPass)
                }
                .tabItem { Label("Result", systemImage: "doc.text.magnifyingglass") }
                .tag(AppRouter.Tab.result)

                // Package
                NavigationStack {
                    PackageView()
                }
                .tabItem { Label("Package", systemImage: "shippingbox") }
                .tag(AppRouter.Tab.package)

                // Settings
                NavigationStack {
                    SettingsView()
                }
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(AppRouter.Tab.settings)
            }
            .environmentObject(router)
        }
    }
}

