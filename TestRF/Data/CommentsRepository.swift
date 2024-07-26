//
//  CommentsRepository.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import Foundation

protocol CommentsRepository {
    func fetchComments(forStory story: Story) async throws -> [Comment]
}

class DefaultCommentsRepository: CommentsRepository {
    private let baseURL = "https://hacker-news.firebaseio.com/v0"
    
    func fetchComments(forStory story: Story) async throws -> [Comment] {
        guard let commentIDs = story.kids else {
            return []
        }
        
        let comments = try await withThrowingTaskGroup(of: Comment.self) { group in
            for id in commentIDs.prefix(5) {
                group.addTask {
                    return try await self.fetchComment(id: id)
                }
            }
            
            var fetchedComments: [Comment] = []
            for try await comment in group {
                fetchedComments.append(comment)
            }
            return fetchedComments
        }
        
        return comments
    }
    
    private func fetchComment(id: Int) async throws -> Comment {
        guard let url = URL(string: "\(baseURL)/item/\(id).json") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let comment = try JSONDecoder().decode(Comment.self, from: data)
        return comment
    }
}
