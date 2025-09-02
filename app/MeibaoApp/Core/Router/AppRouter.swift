import Foundation

final class AppRouter: ObservableObject {
    enum Tab: Hashable { case home, check, result, package, settings }
    @Published var selectedTab: Tab = .home
    @Published var latestResult: ComplianceCheckResult? = nil
    @Published var selectedSchool: School? = nil
}
//用于实现页面之间的栈统一
