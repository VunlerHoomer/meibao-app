import SwiftUI

private extension ComplianceStatus {
    var title: String {
        switch self {
        case .pass: return "通过"
        case .fail: return "不通过"
        case .unknown: return "待确认"
        }
    }
    var color: Color {
        switch self {
        case .pass: return .green
        case .fail: return .red
        case .unknown: return .gray
        }
    }
}

struct ResultView: View {
    let result: ComplianceCheckResult
    @EnvironmentObject private var router: AppRouter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 状态卡
                HStack {
                    Circle().fill(result.status.color).frame(width: 12, height: 12)
                    Text("合规结论：\(result.status.title)")
                        .font(.title3.bold())
                        .foregroundStyle(result.status.color)
                    Spacer()
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                // 风险
                if !result.risks.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("风险与差距").font(.headline)
                        ForEach(result.risks, id: \.self) { r in
                            Label(r, systemImage: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                                .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // 证据
                VStack(alignment: .leading, spacing: 12) {
                    Text("证据（溯源）").font(.headline)
                    ForEach(result.evidences) { ev in
                        EvidenceCard(evidence: ev)
                    }
                }

                // 操作
                Button {
                    router.selectedTab = .package
                } label: {
                    Label("生成材料包", systemImage: "shippingbox")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    router.selectedTab = .home
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { dismiss() }
                } label: {
                    Label("返回首页", systemImage: "house")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle("结果页")
    }
}

#Preview {
    NavigationStack {
        ResultView(result: MockDataService.sampleResultFail)
            .environmentObject(AppRouter())
    }
}

