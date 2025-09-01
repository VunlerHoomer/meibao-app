//
//  SettingsView.swift
//  MeibaoApp
//
//  设置/关于：免责声明、隐私说明、删除报告占位
//

import SwiftUI

struct SettingsView: View {
    @State private var showDeletedToast = false

    var body: some View {
        Form {
            Section("关于") {
                Text("美保评估 · MVP")
                Text("版本：0.1.0")
            }

            Section("隐私 & 免责声明") {
                Text("本应用仅提供信息参考，不提供法律意见，不销售保险，不收集医疗隐私。")
                    .font(.footnote)
            }

            Section("数据管理") {
                Button(role: .destructive) {
                    // 占位：删除本地报告
                    showDeletedToast = true
                } label: {
                    Label("删除本地报告数据", systemImage: "trash")
                }
            }
        }
        .overlay(alignment: .bottom) {
            if showDeletedToast {
                Text("已删除本地报告（占位）")
                    .padding(8)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 12)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation { showDeletedToast = false }
                        }
                    }
            }
        }
        .navigationTitle("设置")
    }
}

#Preview {
    NavigationStack { SettingsView() }
}

