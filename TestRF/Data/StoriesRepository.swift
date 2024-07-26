//
//  StoriesRepository.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import Foundation

protocol StoriesRepository {
    func fetchStories(endpoint: String) async throws -> [Story]
}

class DefaultStoriesRepository: StoriesRepository {
    private let baseURL = "https://hacker-news.firebaseio.com/v0"
    
    func fetchStories(endpoint: String) async throws -> [Story] {
        guard let url = URL(string: "\(baseURL)/\(endpoint).json") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let storyIDs = try JSONDecoder().decode([Int].self, from: data)
        
        let stories = try await withThrowingTaskGroup(of: Story.self) { group in
            for id in storyIDs.prefix(50) {
                group.addTask {
                    return try await self.fetchStory(id: id)
                }
            }
            
            var fetchedStories: [Story] = []
            for try await story in group {
                fetchedStories.append(story)
            }
            return fetchedStories
        }
        
        return stories
    }

    private func fetchStory(id: Int) async throws -> Story {
        guard let url = URL(string: "\(baseURL)/item/\(id).json") else {
            return Story(id: 0, title: "Error", kids: [], url: nil, by: "Unknown", text: "Text not available for this story.", time: 0, score: 0, descendants: 0)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let story = try JSONDecoder().decode(Story.self, from: data)
        return story
    }
}
