//
//  ComplianceMatrixView.swift
//  MeibaoApp
//
//  对照矩阵组件：左列学校要求（用名称表示），右列保单计划的值
//

import SwiftUI

struct ComplianceMatrixView: View {
    let items: [PolicyItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("要求/条款")
                    .font(.headline)
                Spacer()
                Text("计划值")
                    .font(.headline)
            }
            .padding(.vertical, 4)

            Divider()

            ForEach(items) { item in
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.displayName).font(.subheadline).bold()
                        if let excerpt = item.excerpt {
                            Text(excerpt)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer(minLength: 16)
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(item.value)
                            .font(.subheadline)
                        if let url = item.sourceURL {
                            Text(url)
                                .font(.caption2)
                                .foregroundStyle(.blue)
                                .lineLimit(1)
                        }
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
                    Text("暂无对照数据")
                        .font(.headline)
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
        ComplianceMatrixView(items: MockDataService.samplePolicyItems)
            .padding()
    }
}

