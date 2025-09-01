//
//  ResultView.swift
//  MeibaoApp
//
//  结果页：结论卡片 + 证据列表；按钮生成材料包（iOS16 友好写法）
//

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
    @State private var goPackage = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 结论卡
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

                if !result.risks.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("风险提示")
                            .font(.headline)
                        ForEach(result.risks, id: \.self) { r in
                            Label(r, systemImage: "exclamationmark.triangle")
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // 证据列表
                VStack(alignment: .leading, spacing: 12) {
                    Text("证据（溯源）").font(.headline)
                    ForEach(result.evidences) { ev in
                        EvidenceCard(evidence: ev)
                    }
                }

                Button {
                    goPackage = true
                } label: {
                    Label("生成材料包", systemImage: "shippingbox")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("结果页")
        // 👇 用 navigationDestination 代替旧的 NavigationLink(isActive:)
        .navigationDestination(isPresented: $goPackage) {
            PackageView()
        }
    }
}

#Preview {
    NavigationStack {
        ResultView(result: MockDataService.sampleResultPass)
    }
}

