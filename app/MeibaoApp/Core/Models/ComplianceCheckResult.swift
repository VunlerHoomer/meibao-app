//
//  ComplianceCheckResult.swift
//  MeibaoApp
//
//  Created by Vunler on 2025/9/1.
//
//  合规检查结果模型 + 证据
//

import Foundation

enum ComplianceStatus {
    case pass, fail, unknown
}

struct Evidence: Identifiable, Hashable {
    let id: UUID
    let excerpt: String
    let sourceURL: String
    let timestamp: Date
}

struct ComplianceCheckResult: Identifiable, Hashable {
    let id: UUID
    let status: ComplianceStatus
    let risks: [String]
    let evidences: [Evidence]
}
