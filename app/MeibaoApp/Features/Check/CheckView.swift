//
//  CheckView.swift
//  MeibaoApp
//
//  校验页：展示对照矩阵，占位 6 行；按钮进入结果页（iOS16 友好写法）
//

import SwiftUI

struct CheckView: View {
    let school: School
    @State private var items: [PolicyItem] = MockDataService.samplePolicyItems
    @State private var goResult = false
    @State private var result: ComplianceCheckResult = MockDataService.sampleResultPass

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(school.name) (\(school.state))")
                    .font(.headline)

                ComplianceMatrixView(items: items)

                Button {
                    // 假装计算
                    result = MockDataService.fakeEvaluateCompliance(for: school, with: items)
                    goResult = true
                } label: {
                    Label("查看合规结果", systemImage: "checkmark.circle")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("校验页")
        // 👇 用 navigationDestination 代替旧的 NavigationLink(isActive:)
        .navigationDestination(isPresented: $goResult) {
            ResultView(result: result)
        }
    }
}

#Preview {
    NavigationStack {
        CheckView(school: MockDataService.sampleSchools[0])
    }
}

