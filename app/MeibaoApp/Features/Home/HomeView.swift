//
//  HomeView.swift
//  MeibaoApp
//
//  首页：学校选择 + 上传占位（点击后进入校验页）
//

import SwiftUI

struct HomeView: View {
    @State private var selectedSchool: School? = MockDataService.sampleSchools.first
    @State private var showUploadedToast = false
    @State private var goCheck = false

    var body: some View {
        VStack(spacing: 20) {
            Text("美保评估 · MVP")
                .font(.title2.bold())

            Picker("选择学校", selection: $selectedSchool) {
                ForEach(MockDataService.sampleSchools) { school in
                    Text("\(school.name) (\(school.state))")
                        .tag(Optional(school))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 140)
            .navigationDestination(isPresented: $goCheck) {
                CheckView(school: selectedSchool ?? MockDataService.sampleSchools[0])
            }


            Button {
                // 模拟上传
                showUploadedToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    goCheck = true
                }
            } label: {
                Label("上传 PDF/链接（占位）", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderedProminent)

            

            if showUploadedToast {
                Text("已模拟上传 ✓").font(.footnote).foregroundStyle(.green)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("首页")
    }
}

#Preview {
    NavigationStack { HomeView() }
}

