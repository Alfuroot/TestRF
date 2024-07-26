//
//  StoryDetailView.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import SwiftUI

struct StoryDetailView: View {
    @EnvironmentObject var viewModel: NewsViewModel
    let story: Story
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                Text(story.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                HStack {
                    Text("by \(story.by)")
                        .font(.title2)
                        .padding(.bottom)
                    Spacer()
                    Button(action: {
                        viewModel.toggleStory(story)
                    }) {
                        Image(systemName:  viewModel.preferredStories.contains(where: { $0.id == story.id }) ? "heart.fill" : "heart")
                            .padding(.bottom)
                    }
                    .padding()
                }
                Divider()
                Text(story.text ?? "Text preview is not available.")
                    .padding(.bottom)
                Divider()
                if let kids = story.kids, !kids.isEmpty {
                    Text("Comments: \(story.descendants ?? 0)")
                        .font(.title2)
                        .padding(.bottom)
                    
                    if viewModel.loadingComments {
                        ProgressView()
                    } else {
                        ForEach(viewModel.comments, id: \.id) { comment in
                            if (comment.text != "") {
                                Text("\(comment.by) : \(comment.text)")
                                    .padding(.bottom)
                            } else {
                                Text("Comment not available.")
                            }
                        }
                    }
                }
                
                Text("Score: \(story.score)")
                    .font(.title3)
                    .padding(.bottom)
                if let url = story.url, let linkURL = URL(string: url) {
                    Link("Read more", destination: linkURL)
                        .font(.title3)
                        .padding(.bottom)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Story Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.fetchComments(for: story)
        }
    }
}

#Preview {
    StoryDetailView(story: Story(id: 1, title: "StoryTitle", kids: [], url: "", by: "", text: "", time: Date().timeIntervalSince(Date.now), score: 10, descendants: 2))
}
