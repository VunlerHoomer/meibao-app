//
//  PackageView.swift
//  MeibaoApp
//
//  材料包页：三类邮件话术 + 预填表单字段（占位）
//

import SwiftUI

struct PackageView: View {
    enum TemplateKind: String, CaseIterable, Identifiable {
        case insurer = "保险公司"
        case school  = "学校"
        case selfUse = "自留"
        var id: String { rawValue }
    }

    @State private var selected: TemplateKind = .insurer

    let formFields: [String] = [
        "姓名（英文）", "学号/申请号", "出生日期", "邮箱", "学校", "险种名称", "保单号", "覆盖起止日期"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("模板类型", selection: $selected) {
                ForEach(TemplateKind.allCases) { t in
                    Text(t.rawValue).tag(t)
                }
            }
            .pickerStyle(.segmented)

            GroupBox("邮件话术（占位）") {
                Text(sampleTemplate(for: selected))
                    .font(.subheadline)
                    .padding(.vertical, 4)
            }

            GroupBox("预填字段（占位）") {
                ForEach(formFields, id: \.self) { f in
                    Label(f, systemImage: "checkmark.circle")
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("材料包")
    }

    private func sampleTemplate(for kind: TemplateKind) -> String {
        switch kind {
        case .insurer:
            return "尊敬的保险公司，烦请出具覆盖证明（含保额/免赔/撤离/遣返/就医网络等），用于学校豁免。谢谢！"
        case .school:
            return "Dear Insurance Office, 我已随信附上保单与对照说明，请协助豁免校保。"
        case .selfUse:
            return "自留备忘：按清单核查是否包含：医疗10万、撤离5万、遣返2.5万、免赔≤500、网络半径等。"
        }
    }
}

#Preview {
    NavigationStack { PackageView() }
}

