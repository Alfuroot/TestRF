//
//  ContentView.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    
    var body: some View {
        TabView {
            StoryListView(stories: $viewModel.newsStories, title: "News Stories", fetchAction: viewModel.fetchAllStories)
                .tabItem { Label("News", systemImage: "newspaper") }
            StoryListView(stories: $viewModel.topStories, title: "Top Stories", fetchAction: viewModel.fetchAllStories)
                .tabItem { Label("Top", systemImage: "flame") }
            StoryListView(stories: $viewModel.bestStories, title: "Best Stories", fetchAction: viewModel.fetchAllStories)
                .tabItem { Label("Best", systemImage: "star") }
            StoryListView(stories: $viewModel.preferredStories, title: "Preferred Stories", fetchAction: viewModel.fetchAllStories)
                .tabItem { Label("Preferred", systemImage: "heart") }
        }
        .onAppear {
            viewModel.fetchAllStories()
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
