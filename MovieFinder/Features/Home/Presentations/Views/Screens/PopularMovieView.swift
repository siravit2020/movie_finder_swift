//
//  PopularMovieView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 27/8/2568 BE.
//

import FactoryKit
import SwiftUI

struct PopularMovieView: View {
    @InjectedObject(\.popularMoviesViewModel) private var viewModel

    var body: some View {
        MovieListView(
            title: "Popular Movies",
            items: viewModel.items,
            onItemAppear: { item in
                viewModel.fetchMoreItemsIfNeeded(currentItem: item)
            },
            canLoadMore: viewModel.canLoadMore
        )
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.fetchInitialItems()
            }
        }
    }
}

#Preview {
    let _ = Container.shared.movieRepository.register { MockHomeRepository() }
    PopularMovieView()
}
