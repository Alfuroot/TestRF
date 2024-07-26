//
//  StoryListView.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import SwiftUI

struct StoryListView: View {
    @EnvironmentObject var viewModel: NewsViewModel
    @Binding var stories: [Story]
    let title: String
    let fetchAction: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loadingNews || viewModel.loadingTop || viewModel.loadingBest {
                    ProgressView("Loading Stories...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    if !stories.isEmpty {
                        List(stories) { story in
                            NavigationLink(destination: StoryDetailView(story: story)) {
                                StoryRow(story: story)
                            }
                        }
                        .navigationTitle(title)
                        .refreshable {
                            fetchAction()
                        }
                    } else {
                        Text("No stories available, tap to refresh")
                            .onTapGesture {
                               fetchAction()
                            }
                    }
                }
            }
        }.onAppear {
            fetchAction()
        }
    }
}

#Preview {
    StoryListView(stories: .constant([]), title: "Sample Stories", fetchAction: {})
}
