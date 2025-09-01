//
//  School.swift
//  MeibaoApp
//
//  Created by Vunler on 2025/9/1.
//
//
//  学校模型
//

import Foundation

struct School: Identifiable, Hashable {
    let id: UUID
    let name: String
    let state: String
    let portalHint: String?
}
