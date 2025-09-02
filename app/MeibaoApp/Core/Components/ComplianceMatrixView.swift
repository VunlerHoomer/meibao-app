//
//  ComplianceMatrixView.swift
//  MeibaoApp
//

import SwiftUI

struct ComplianceMatrixView: View {
    let items: [PolicyItem]
    let requireds: [String: Int]?   // 新增：学校要求（按 key 对齐）

    private func passIcon(for item: PolicyItem) -> (String, Color)? {
        guard let reqs = requireds,
              let need = reqs[item.key],
              let actual = Int(item.value) else { return nil }

        if item.key == "deductible" {
            // 免赔额：实际 ≤ 要求 → 通过
            return actual <= need ? ("checkmark.seal.fill", .green) : ("xmark.octagon.fill", .red)
        } else {
            // 其它：实际 ≥ 要求 → 通过
            return actual >= need ? ("checkmark.seal.fill", .green) : ("xmark.octagon.fill", .red)
        }
    }

    private func requiredText(for key: String) -> String {
        guard let reqs = requireds, let v = reqs[key] else { return "-" }
        return "\(v)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("条款").font(.headline)
                Spacer()
                Text("实际").font(.headline)
                    .frame(width: 90, alignment: .trailing)
                Text("要求").font(.headline)
                    .frame(width: 90, alignment: .trailing)
                Text("结果").font(.headline)
                    .frame(width: 44, alignment: .center)
            }
            .padding(.vertical, 4)

            Divider()

            ForEach(items) { item in
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.displayName).font(.subheadline).bold()
                        if let excerpt = item.excerpt {
                            Text(excerpt).font(.caption).foregroundStyle(.secondary).lineLimit(2)
                        }
                    }
                    Spacer(minLength: 12)
                    Text(item.value)
                        .frame(width: 90, alignment: .trailing)
                        .font(.subheadline)

                    Text(requiredText(for: item.key))
                        .frame(width: 90, alignment: .trailing)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if let (symbol, color) = passIcon(for: item) {
                        Image(systemName: symbol)
                            .foregroundStyle(color)
                            .frame(width: 44)
                    } else {
                        Text("-").frame(width: 44)
                    }
                }
                .padding(.vertical, 6)
                Divider()
            }

            if items.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("暂无对照数据").font(.headline)
                    Text("请返回并重新上传保单 PDF/链接")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ScrollView {
        ComplianceMatrixView(items: MockDataService.samplePolicyItems,
                             requireds: ["medical_max": 100000, "deductible": 500, "evacuation": 50000, "repatriation": 25000])
            .padding()
    }
}

