//
//  HomeView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 17/7/2568 BE.
//

import FactoryKit
import SwiftUI

struct HomeView: View {
    @InjectedObject(\.homeViewModel) private var viewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if viewModel.isLoading {
                        HomeSkeletonView()
                    } else {
                        AccountSection()

                        if let movieList = viewModel.nowShowing {
                            HomeNowShowing(movieList: movieList)
                        }

                        if let movieList = viewModel.popular {
                            HomePopular(movieList: movieList)
                        }
                    }
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(Color.primaryBackground)
            .task {
                if viewModel.nowShowing == nil || viewModel.popular == nil {
                    await viewModel.loadMovies()
                }
            }
        }

    }
}

#Preview {
    let _ = Container.shared.movieRepository.register { MockHomeRepository() }
    HomeView()
}
