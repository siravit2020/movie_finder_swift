//
//  SkeletonView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 1/1/2569 BE.
//

import SwiftUI

// MARK: - Base Skeleton Shape

struct SkeletonShape: View {
    var cornerRadius: CGFloat = 8
    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    colors: [
                        Color.gray.opacity(0.3),
                        Color.gray.opacity(0.1),
                        Color.gray.opacity(0.3),
                    ],
                    startPoint: UnitPoint(
                        x: isAnimating ? 0.5 : -1,
                        y: isAnimating ? 0.5 : -0.5
                    ),
                    endPoint: UnitPoint(
                        x: isAnimating ? 2 : 0.5,
                        y: isAnimating ? 1.5 : 0.5
                    )
                )
            )
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2).repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Skeleton Movie List Item (for Now Showing)

struct SkeletonMovieListItem: View {
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                SkeletonShape(cornerRadius: 12)
                    .aspectRatio(2 / 3, contentMode: .fit)
                    .padding(.bottom, 20)

                // Circle progress skeleton
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .padding(.leading, 8)
            }

            // Title skeleton
            SkeletonShape()
                .frame(height: 16)
                .padding(.leading, 8)
                .padding(.trailing, 16)

            SkeletonShape()
                .frame(width: 80, height: 16)
                .padding(.leading, 8)
                .padding(.top, 4)
        }
    }
}

// MARK: - Skeleton Movie Row (for Popular)

struct SkeletonMovieRow: View {
    var body: some View {
        HStack(alignment: .top) {
            SkeletonShape(cornerRadius: 12)
                .frame(width: 100, height: 150)
                .padding(.trailing, .Spacing.space8)

            VStack(alignment: .leading) {
                // Title
                SkeletonShape()
                    .frame(width: 180, height: 18)
                    .padding(.bottom, .Spacing.space4)

                // Release date
                SkeletonShape()
                    .frame(width: 100, height: 14)
                    .padding(.bottom, .Spacing.space4)

                // Popularity
                SkeletonShape()
                    .frame(width: 80, height: 14)
                    .padding(.bottom, .Spacing.space8)

                // Circle progress
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
            }
        }
    }
}

// MARK: - Skeleton Now Showing Section

struct SkeletonNowShowingSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Header skeleton
            HStack {
                SkeletonShape()
                    .frame(width: 120, height: 20)
                Spacer()
                SkeletonShape()
                    .frame(width: 60, height: 16)
            }
            .padding(.horizontal, .Spacing.space24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: .Spacing.space16) {
                    ForEach(0..<5, id: \.self) { _ in
                        SkeletonMovieListItem()
                            .frame(width: 150)
                    }
                }
                .padding(.horizontal, .Spacing.space24)
                .padding(.vertical, .Spacing.space16)
            }
        }
    }
}

// MARK: - Skeleton Popular Section

struct SkeletonPopularSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Header skeleton
            HStack {
                SkeletonShape()
                    .frame(width: 80, height: 20)
                Spacer()
                SkeletonShape()
                    .frame(width: 60, height: 16)
            }
            .padding(.horizontal, .Spacing.space24)

            VStack(alignment: .leading, spacing: .Spacing.space16) {
                ForEach(0..<3, id: \.self) { _ in
                    SkeletonMovieRow()
                }
            }
            .padding(.horizontal, .Spacing.space24)
            .padding(.vertical, .Spacing.space16)
        }
    }
}

// MARK: - Full Home Skeleton View

struct HomeSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Account section skeleton
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 8) {
                    SkeletonShape()
                        .frame(width: 100, height: 14)
                    SkeletonShape()
                        .frame(width: 150, height: 18)
                }
            }
            .padding(.horizontal, .Spacing.space24)
            .padding(.vertical, .Spacing.space16)

            SkeletonNowShowingSection()

            SkeletonPopularSection()
        }
    }
}

#Preview("Skeleton Movie List Item") {
    SkeletonMovieListItem()
        .frame(width: 150)
        .padding()
        .background(Color.primaryBackground)
}

#Preview("Skeleton Movie Row") {
    SkeletonMovieRow()
        .padding()
        .background(Color.primaryBackground)
}

#Preview("Home Skeleton View") {
    HomeSkeletonView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground)
}
