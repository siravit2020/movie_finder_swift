//
//  NowShowingView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 27/8/2568 BE.
//

import FactoryKit
import SwiftUI

struct NowShowingView: View {
    @InjectedObject(\.nowShowingMoviesViewModel) private var viewModel

    var body: some View {
        MovieListView(
            title: "Now Showing",
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
    NowShowingView()
}
