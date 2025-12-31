//
//  ContentView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 17/7/2568 BE.
//

import FactoryKit
import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .home
    @AppStorage("isDarkMode") private var isDarkMode = true


    enum Tab {
        case home
        case search
        case watchList
    }

    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)

            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search)

            WatchlistView()
                .tabItem {
                    Label("WatchList", systemImage: "person.circle")
                }
                .tag(Tab.watchList)
        }.preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    let _ = Container.shared.movieRepository.register { MockHomeRepository() }
    ContentView()
}
