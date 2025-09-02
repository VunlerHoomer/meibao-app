import SwiftUI

struct CheckView: View {
    let school: School
    @EnvironmentObject private var router: AppRouter

    // 允许空参兜底，避免历史代码遗漏
    init(school: School = School(id: UUID(), name: "UCSD", state: "CA", portalHint: "AHP")) {
        self.school = school
    }

    @State private var items: [PolicyItem] = MockDataService.samplePolicyItems

    enum DemoCase: String, CaseIterable, Identifiable {
        case real = "真实校验"
        case pass = "演示通过"
        case fail = "演示不通过"
        case unknown = "演示存疑"
        var id: String { rawValue }
    }
    @State private var demo: DemoCase = .real

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(school.name) (\(school.state))").font(.headline)

                let reqs = MockDataService.requirementsMap(for: school)
                ComplianceMatrixView(items: items, requireds: reqs)

                Picker("模式", selection: $demo) {
                    ForEach(DemoCase.allCases) { c in
                        Text(c.rawValue).tag(c)
                    }
                }
                .pickerStyle(.segmented)

                Button {
                    let result: ComplianceCheckResult
                    switch demo {
                    case .real:
                        result = MockDataService.checkCompliance(for: school, with: items)
                    case .pass:
                        result = MockDataService.sampleResultPass
                    case .fail:
                        result = MockDataService.sampleResultFail
                    case .unknown:
                        result = MockDataService.sampleResultUncertain
                    }
                    router.latestResult = result           // 交给 Result 标签显示
                    router.selectedTab = .result           // 切到 Result
                } label: {
                    Label("查看合规结果", systemImage: "checkmark.circle")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("校验页")
    }
}

#Preview {
    NavigationStack {
        CheckView().environmentObject(AppRouter())
    }
}

