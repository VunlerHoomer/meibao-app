//
//  MockDataService.swift
//  MeibaoApp
//
//  假数据/占位解析服务
//

import Foundation

enum MockDataService {
    static let sampleSchools: [School] = [
        School(id: UUID(), name: "UCSD",  state: "CA", portalHint: "AHP"),
        School(id: UUID(), name: "USC",   state: "CA", portalHint: "Aetna"),
        School(id: UUID(), name: "NYU",   state: "NY", portalHint: "Gallagher"),
        School(id: UUID(), name: "NEU",   state: "MA", portalHint: "UHCSR"),
        School(id: UUID(), name: "UCLA",  state: "CA", portalHint: "AHP"),
        School(id: UUID(), name: "UCB",   state: "CA", portalHint: "Gallagher"),
        School(id: UUID(), name: "CMU",   state: "PA", portalHint: "UHP"),
        School(id: UUID(), name: "UMich", state: "MI", portalHint: "Aetna")
    ]

    static let samplePolicyItems: [PolicyItem] = [
        PolicyItem(id: UUID(), key: "medical_max", displayName: "医疗保额", value: "USD 100,000", unit: "USD", sourceURL: "https://example.org/policy#medical", excerpt: "Medical maximum at least $100,000.", timestamp: Date()),
        PolicyItem(id: UUID(), key: "evac", displayName: "紧急医疗撤离", value: "USD 50,000", unit: "USD", sourceURL: "https://example.org/policy#evac", excerpt: "Emergency evacuation coverage $50,000.", timestamp: Date()),
        PolicyItem(id: UUID(), key: "repat", displayName: "遗体遣返", value: "USD 25,000", unit: "USD", sourceURL: "https://example.org/policy#repat", excerpt: "Repatriation of remains $25,000.", timestamp: Date()),
        PolicyItem(id: UUID(), key: "deductible", displayName: "免赔额", value: "USD 250", unit: "USD", sourceURL: "https://example.org/policy#deductible", excerpt: "Deductible not to exceed $500.", timestamp: Date()),
        PolicyItem(id: UUID(), key: "network_radius", displayName: "网络半径", value: "40 miles", unit: nil, sourceURL: "https://example.org/policy#network", excerpt: "Network radius within 40 miles.", timestamp: Date()),
        PolicyItem(id: UUID(), key: "waiting_period", displayName: "等待期", value: "0 day", unit: nil, sourceURL: "https://example.org/policy#wait", excerpt: "No waiting period for basic coverage.", timestamp: Date())
    ]

    static let sampleEvidences: [Evidence] = [
        Evidence(id: UUID(), excerpt: "Minimum medical coverage must be $100,000.", sourceURL: "https://example.org/j1#req", timestamp: Date()),
        Evidence(id: UUID(), excerpt: "Emergency evacuation at least $50,000.", sourceURL: "https://example.org/j1#evac", timestamp: Date()),
        Evidence(id: UUID(), excerpt: "Repatriation of remains $25,000.", sourceURL: "https://example.org/j1#repat", timestamp: Date())
    ]

    static let sampleResultPass = ComplianceCheckResult(
        id: UUID(),
        status: .pass,
        risks: ["请按时提交豁免材料，避免逾期。"],
        evidences: sampleEvidences
    )

    static let sampleResultFail = ComplianceCheckResult(
        id: UUID(),
        status: .fail,
        risks: ["医疗保额不足 $100,000", "未包含紧急医疗撤离 $50,000"],
        evidences: sampleEvidences
    )

    static func fakeEvaluateCompliance(for school: School, with items: [PolicyItem]) -> ComplianceCheckResult {
        // 简单的“假装计算”：如果包含 medical_max=USD 100,000 则 pass，否则 unknown
        let hasMinMedical = items.contains { $0.key == "medical_max" && $0.value.contains("100,000") }
        if hasMinMedical {
            return sampleResultPass
        } else {
            return ComplianceCheckResult(id: UUID(), status: .unknown, risks: ["条款不完整，无法判定，建议补充材料"], evidences: sampleEvidences)
        }
    }
}

