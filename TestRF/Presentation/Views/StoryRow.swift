//
//  StoryRow.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import SwiftUI

struct StoryRow: View {
    let story: Story

    var body: some View {
        VStack(alignment: .leading) {
            Text(story.title)
                .font(.headline)
            Text("by \(story.by)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    StoryRow(story: Story(id: 1, title: "StoryTitle", kids: [], url: "", by: "", text: "", time: Date().timeIntervalSince(Date.now), score: 10, descendants: 2))
}
