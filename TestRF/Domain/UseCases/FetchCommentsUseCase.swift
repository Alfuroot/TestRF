//
//  FetchCommentsUseCase.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import Foundation

protocol FetchCommentsUseCase {
    func execute(for story: Story) async throws -> [Comment]
}

class DefaultFetchCommentsUseCase: FetchCommentsUseCase {
    private let repository: CommentsRepository

    init(repository: CommentsRepository = DefaultCommentsRepository()) {
        self.repository = repository
    }

    func execute(for story: Story) async throws -> [Comment] {
        try await repository.fetchComments(forStory: story)
    }
}
