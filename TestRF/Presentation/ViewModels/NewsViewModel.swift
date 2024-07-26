//
//  NewsViewModel.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import Foundation

@MainActor
class NewsViewModel: ObservableObject {
    @Published var newsStories: [Story] = []
    @Published var topStories: [Story] = []
    @Published var bestStories: [Story] = []
    @Published var preferredStories: [Story] = []
    @Published var comments: [Comment] = []
    @Published var loadingComments: Bool = false
    @Published var loadingNews: Bool = false
    @Published var loadingTop: Bool = false
    @Published var loadingBest: Bool = false
    
    private let fetchCommentsUseCase: FetchCommentsUseCase
    private let fetchStoriesUseCase: FetchStoriesUseCase
    
    init(
        fetchStoriesUseCase: FetchStoriesUseCase = DefaultFetchStoriesUseCase(),
        fetchCommentsUseCase: FetchCommentsUseCase = DefaultFetchCommentsUseCase()
    ) {
        self.fetchStoriesUseCase = fetchStoriesUseCase
        self.fetchCommentsUseCase = fetchCommentsUseCase
    }
    
    func fetchComments(for story: Story) {
        guard !loadingComments else { return }
        
        loadingComments = true
        
        Task {
            do {
                let fetchedComments = try await fetchCommentsUseCase.execute(for: story)
                DispatchQueue.main.async {
                    self.comments = fetchedComments
                    self.loadingComments = false
                }
            } catch {
                print("Error fetching comments: \(error)")
                DispatchQueue.main.async {
                    self.loadingComments = false
                }
            }
            
        }
    }
    
    func fetchAllStories() {
        loadingNews = true
        loadingTop = true
        loadingBest = true
        
        Task {
            do {
                async let news = fetchStoriesUseCase.execute(endpoint: "newstories")
                async let top = fetchStoriesUseCase.execute(endpoint: "topstories")
                async let best = fetchStoriesUseCase.execute(endpoint: "beststories")
                
                newsStories = try await news.sorted { $0.time > $1.time }
                topStories = try await top.sorted { $0.score > $1.score }
                bestStories = try await best.sorted { $0.score > $1.score }
                DispatchQueue.main.async {
                    self.loadingNews = false
                    self.loadingTop = false
                    self.loadingBest = false
                }
            } catch {
                print("Failed to fetch stories: \(error)")
            }
        }
    }
    
    func toggleStory(_ story: Story) {
        if let index = preferredStories.firstIndex(where: { $0.id == story.id }) {
            preferredStories.remove(at: index)
        } else {
            preferredStories.append(story)
        }
    }
}
