//
//  MockDataService.swift
//  MeibaoApp
//

import Foundation

enum MockDataService {
    // MARK: - 样例兜底数据（保留）
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
        PolicyItem(id: UUID(), key: "medical_max",  displayName: "医疗保额",  value: "100000", unit: "USD", sourceURL: "https://example.com", excerpt: "Coverage up to $100,000",       timestamp: Date()),
        PolicyItem(id: UUID(), key: "deductible",   displayName: "免赔额",    value: "500",    unit: "USD", sourceURL: "https://example.com", excerpt: "Deductible $500",            timestamp: Date()),
        PolicyItem(id: UUID(), key: "evacuation",   displayName: "医疗撤离",  value: "50000",  unit: "USD", sourceURL: "https://example.com", excerpt: "Medical evacuation $50,000", timestamp: Date()),
        PolicyItem(id: UUID(), key: "repatriation", displayName: "遗体遣返",  value: "25000",  unit: "USD", sourceURL: "https://example.com", excerpt: "Repatriation $25,000",       timestamp: Date())
    ]

    static let sampleEvidences: [Evidence] = [
        Evidence(id: UUID(), excerpt: "Policy covers $100,000 medical maximum.", sourceURL: "https://example.com", timestamp: Date()),
        Evidence(id: UUID(), excerpt: "Deductible limited to $500.",             sourceURL: "https://example.com", timestamp: Date()),
        Evidence(id: UUID(), excerpt: "Includes evacuation and repatriation.",   sourceURL: "https://example.com", timestamp: Date())
    ]

    // ✅ Day 7：三种示例结果
    static let sampleResultPass = ComplianceCheckResult(
        id: UUID(), status: .pass, risks: [], evidences: sampleEvidences
    )
    static let sampleResultFail = ComplianceCheckResult(
        id: UUID(), status: .fail,
        risks: [
            "医疗保额不足（需 ≥ 100000，实际 80000）",
            "免赔额过高（需 ≤ 500，实际 1000）"
        ],
        evidences: sampleEvidences
    )
    static let sampleResultUncertain = ComplianceCheckResult(
        id: UUID(), status: .unknown,
        risks: ["条款截取不完整，建议人工核对"],
        evidences: sampleEvidences
    )

    // MARK: - 缓存 & 读取学校列表（给 Home 用）
    private static var _cachedSchools: [School]? = nil
    static func loadSchoolsFromJSON() -> [School] {
        if let cached = _cachedSchools { return cached }
        guard let url = Bundle.main.url(forResource: "MockData", withExtension: "json") else {
            _cachedSchools = sampleSchools; return sampleSchools
        }
        do {
            let data = try Data(contentsOf: url)
            let root = try JSONDecoder().decode(MockRootDTO.self, from: data)
            let schools = root.schools.map { dto in
                School(id: UUID(), name: dto.name, state: dto.state, portalHint: dto.portalHint)
            }
            _cachedSchools = schools
            return schools
        } catch {
            _cachedSchools = sampleSchools
            return sampleSchools
        }
    }

    // MARK: - 读取某学校的最低要求（key 对齐 PolicyItem.key）
    static func requirementsMap(for school: School) -> [String: Int]? {
        guard let url = Bundle.main.url(forResource: "MockData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let root = try? JSONDecoder().decode(MockRootDTO.self, from: data),
              let dto = root.schools.first(where: { $0.name == school.name }),
              let req = dto.requirements
        else { return nil }
        return [
            "medical_max": req.medical_max,
            "deductible": req.deductible,
            "evacuation": req.evacuation,
            "repatriation": req.repatriation
        ]
    }

    // MARK: - 真实判定（Day 6 已实现，保留可用）
    static func checkCompliance(for school: School, with items: [PolicyItem]) -> ComplianceCheckResult {
        guard let reqs = requirementsMap(for: school) else {
            return ComplianceCheckResult(id: UUID(), status: .unknown, risks: ["未找到该校要求，建议人工核对"], evidences: sampleEvidences)
        }
        func intValue(_ key: String) -> Int? {
            if let s = items.first(where: { $0.key == key })?.value, let v = Int(s) { return v }
            return nil
        }
        var risks: [String] = []
        if let actual = intValue("medical_max"), let need = reqs["medical_max"], actual < need { risks.append("医疗保额不足（需 ≥ \(need)，实际 \(actual)）") }
        if let actual = intValue("evacuation"), let need = reqs["evacuation"], actual < need { risks.append("医疗撤离不足（需 ≥ \(need)，实际 \(actual)）") }
        if let actual = intValue("repatriation"), let need = reqs["repatriation"], actual < need { risks.append("遗体遣返不足（需 ≥ \(need)，实际 \(actual)）") }
        if let actual = intValue("deductible"), let need = reqs["deductible"], actual > need { risks.append("免赔额过高（需 ≤ \(need)，实际 \(actual)）") }
        let status: ComplianceStatus = risks.isEmpty ? .pass : .fail
        return ComplianceCheckResult(id: UUID(), status: status, risks: risks, evidences: sampleEvidences)
    }
}

// MARK: - JSON DTO
private struct MockRootDTO: Decodable {
    let schools: [SchoolDTO]
}
private struct SchoolDTO: Decodable {
    let name: String
    let state: String
    let portalHint: String?
    let requirements: RequirementDTO?
}
private struct RequirementDTO: Decodable {
    let medical_max: Int
    let deductible: Int
    let evacuation: Int
    let repatriation: Int
}

