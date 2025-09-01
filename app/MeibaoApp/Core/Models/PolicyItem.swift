//
//  PolicyItem.swift
//  MeibaoApp
//
//  Created by Vunler on 2025/9/1.
//
//
//  保单条款项模型（用于对照矩阵）
//

import Foundation

struct PolicyItem: Identifiable, Hashable {
    let id: UUID
    let key: String                // internal key, e.g. "medical_max"
    let displayName: String       // 显示名：例如“医疗保额”
    let value: String             // 计划值：例如 "USD 100,000"
    let unit: String?             // 单位：例如 "USD"（可空）
    let sourceURL: String?        // 溯源链接（可空）
    let excerpt: String?          // 原文片段（可空）
    let timestamp: Date           // 时间戳
}
