//
//  EvidenceCard.swift
//  MeibaoApp
//
//  证据卡片：原文片段 + 链接 + 时间戳
//

import SwiftUI

struct EvidenceCard: View {
    let evidence: Evidence

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(evidence.excerpt)
                .font(.subheadline)
            HStack {
                Image(systemName: "link")
                Text(evidence.sourceURL)
                    .font(.caption)
                    .lineLimit(1)
            }
            .foregroundStyle(.blue)

            Text("时间：\(evidence.timestamp.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: 12) {
        ForEach(MockDataService.sampleEvidences) { ev in
            EvidenceCard(evidence: ev)
        }
    }
    .padding()
}

