import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter

    @State private var schools: [School] = MockDataService.loadSchoolsFromJSON()
    @State private var selectedSchool: School? = nil
    @State private var showUploadedToast = false

    var body: some View {
        VStack(spacing: 20) {
            Text("美保评估 · MVP").font(.title2.bold())

            Picker("选择学校", selection: $selectedSchool) {
                ForEach(schools) { school in
                    Text("\(school.name) (\(school.state))").tag(Optional(school))
                }
            }
            .pickerStyle(.wheel)        // 若跑 macOS 目标可改 .menu/.segmented
            .frame(height: 140)
            .onAppear { if selectedSchool == nil { selectedSchool = schools.first } }

            Button {
                // 模拟上传 → 记录选择 → 切到 Check 标签
                showUploadedToast = true
                router.selectedSchool = selectedSchool
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    router.selectedTab = .check
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
    NavigationStack { HomeView().environmentObject(AppRouter()) }
}

