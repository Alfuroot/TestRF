//
//  FetchStoriesUseCase.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import Foundation

protocol FetchStoriesUseCase {
    func execute(endpoint: String) async throws -> [Story]
}

class DefaultFetchStoriesUseCase: FetchStoriesUseCase {
    private let repository: StoriesRepository
    
    init(repository: StoriesRepository = DefaultStoriesRepository()) {
        self.repository = repository
    }

    func execute(endpoint: String) async throws -> [Story] {
        return try await repository.fetchStories(endpoint: endpoint)
    }
}
