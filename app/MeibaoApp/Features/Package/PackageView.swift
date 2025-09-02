//
//  PackageView.swift
//  MeibaoApp
//

import SwiftUI

struct PackageView: View {
    @EnvironmentObject private var router: AppRouter

    // Editable fields the user may want to put in emails
    @State private var studentName: String = ""
    @State private var studentID: String = ""
    @State private var policyNumber: String = ""
    @State private var planName: String = ""

    enum TemplateKind: String, CaseIterable, Identifiable {
        case insurance = "To Insurance"
        case school = "To School"
        case selfnote = "Self Note"
        var id: String { rawValue }
    }
    @State private var kind: TemplateKind = .insurance

    @State private var copiedToast: String? = nil

    // Convenience
    private var schoolName: String {
        router.selectedSchool?.name ?? "Your University"
    }
    private var resultStatus: ComplianceStatus {
        router.latestResult?.status ?? .unknown
    }
    private var risks: [String] {
        router.latestResult?.risks ?? []
    }
    private var risksBulletList: String {
        guard !risks.isEmpty else { return "• None" }
        return risks.map { "• \($0)" }.joined(separator: "\n")
    }

    // MARK: - Subjects
    private var subject: String {
        switch kind {
        case .insurance:
            return "[Policy Verification] \(schoolName) waiver requirements"
        case .school:
            return "[Waiver Support Request] \(schoolName) student health insurance"
        case .selfnote:
            return "[Meibao] \(schoolName) – my waiver package"
        }
    }

    // MARK: - Bodies (English templates)
    private var bodyText: String {
        switch kind {
        case .insurance:
            return """
            Dear Insurance Support Team,

            I am currently preparing a health insurance waiver submission for \(schoolName).
            Could you please help confirm whether my plan meets the school’s minimum requirements?

            Student name: \(studentName.isEmpty ? "[Your Name]" : studentName)
            Student ID: \(studentID.isEmpty ? "[Your Student ID]" : studentID)
            Plan name: \(planName.isEmpty ? "[Plan Name]" : planName)
            Policy number: \(policyNumber.isEmpty ? "[Policy Number]" : policyNumber)

            Latest evaluation by Meibao:
            - Overall status: \(statusText(resultStatus))
            - Findings:
            \(risksBulletList)

            Specifically, the school requires minimum thresholds (examples):
            - Medical maximum ≥ $100,000
            - Medical evacuation ≥ $50,000
            - Repatriation of remains ≥ $25,000
            - Deductible ≤ $500 (some schools allow up to $1,500)

            If anything is missing, could you advise how to obtain an official confirmation letter or rider?
            A short confirmation stating the plan meets the above thresholds would be greatly appreciated.

            Thank you for your assistance.

            Best regards,
            \(studentName.isEmpty ? "[Your Name]" : studentName)
            """

        case .school:
            return """
            To whom it may concern at \(schoolName),

            I am submitting a health insurance waiver and would like to request guidance/verification.

            Student name: \(studentName.isEmpty ? "[Your Name]" : studentName)
            Student ID: \(studentID.isEmpty ? "[Your Student ID]" : studentID)
            Plan name: \(planName.isEmpty ? "[Plan Name]" : planName)
            Policy number: \(policyNumber.isEmpty ? "[Policy Number]" : policyNumber)

            Meibao evaluation summary:
            - Overall status: \(statusText(resultStatus))
            - Findings:
            \(risksBulletList)

            I understand the general minimums are commonly:
            • Medical maximum ≥ $100,000
            • Medical evacuation ≥ $50,000
            • Repatriation of remains ≥ $25,000
            • Deductible ≤ $500 (note: some schools specify ≤ $1,500)

            Please let me know if additional documentation is required (e.g., confirmation letter, rider, or policy page reference).
            I will be happy to provide any missing materials.

            Thank you for your time and support.

            Sincerely,
            \(studentName.isEmpty ? "[Your Name]" : studentName)
            """

        case .selfnote:
            return """
            Meibao – My Waiver Package Notes

            School: \(schoolName)
            Status: \(statusText(resultStatus))

            Findings:
            \(risksBulletList)

            Attach/collect:
            • Policy certificate (includes plan name and policy number)
            • Benefits summary page showing medical max, deductible, evacuation, repatriation
            • If needed: insurer confirmation letter/rider

            Personal info
            • Student name: \(studentName.isEmpty ? "[Your Name]" : studentName)
            • Student ID: \(studentID.isEmpty ? "[Your Student ID]" : studentID)
            • Plan name: \(planName.isEmpty ? "[Plan Name]" : planName)
            • Policy number: \(policyNumber.isEmpty ? "[Policy Number]" : policyNumber)

            Next steps
            1) Email insurer for confirmation (if any deficit or unclear benefit)
            2) Upload waiver on the school portal with supporting pages
            3) Keep a copy of all files and confirmation for resubmission next term
            """
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Header
                Text("Materials Package").font(.title2.bold())
                Text("Auto-filled with school and evaluation details (English templates).")
                    .font(.subheadline).foregroundStyle(.secondary)

                // Template picker
                Picker("Template", selection: $kind) {
                    ForEach(TemplateKind.allCases) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.segmented)

                // Prefill fields
                Group {
                    TextField("Student name", text: $studentName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Student ID", text: $studentID)
                        .textFieldStyle(.roundedBorder)
                    TextField("Plan name", text: $planName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Policy number", text: $policyNumber)
                        .textFieldStyle(.roundedBorder)
                }

                // Subject
                HStack {
                    Text("Subject").font(.headline)
                    Spacer()
                    Button {
                        copyToClipboard(subject)
                        showToast("Subject copied")
                    } label: { Label("Copy", systemImage: "doc.on.doc") }
                        .buttonStyle(.bordered)
                }
                TextEditor(text: .constant(subject))
                    .frame(minHeight: 48)
                    .font(.body.monospaced())
                    .disabled(true)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.quaternary))

                // Body
                HStack {
                    Text("Body").font(.headline)
                    Spacer()
                    Button {
                        copyToClipboard(bodyText)
                        showToast("Body copied")
                    } label: { Label("Copy", systemImage: "doc.on.doc") }
                        .buttonStyle(.bordered)
                }
                TextEditor(text: .constant(bodyText))
                    .frame(minHeight: 260)
                    .font(.body.monospaced())
                    .disabled(true)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.quaternary))

                // Quick actions
                HStack {
                    Button {
                        // Open Mail app prefilled via mailto:
                        let subj = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let body = bodyText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        if let url = URL(string: "mailto:?subject=\(subj)&body=\(body)") {
                            #if os(iOS)
                            UIApplication.shared.open(url)
                            #endif
                        }
                    } label: {
                        Label("Open Mail (prefilled)", systemImage: "envelope.open")
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        router.selectedTab = .home
                    } label: {
                        Label("Back to Home", systemImage: "house")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .navigationTitle("Package")
        .overlay(alignment: .bottom) {
            if let toast = copiedToast {
                Text(toast)
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 12)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation { copiedToast = nil }
                        }
                    }
            }
        }
    }

    private func statusText(_ s: ComplianceStatus) -> String {
        switch s {
        case .pass: return "Pass"
        case .fail: return "Fail"
        case .unknown: return "Unknown"
        }
    }

    private func copyToClipboard(_ text: String) {
        #if os(iOS)
        UIPasteboard.general.string = text
        #endif
    }

    private func showToast(_ text: String) {
        withAnimation { copiedToast = text }
    }
}

#Preview {
    NavigationStack {
        PackageView()
            .environmentObject({
                let r = AppRouter()
                r.selectedSchool = School(id: UUID(), name: "UCSD", state: "CA", portalHint: "AHP")
                r.latestResult = MockDataService.sampleResultFail
                return r
            }())
    }
}

