//
//  MovieDetailSkeletonView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 1/1/2569 BE.
//

import SwiftUI

// MARK: - Movie Detail Skeleton View

struct MovieDetailSkeletonView: View {
    let maxWidth: CGFloat
    let maxHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Backdrop skeleton
            Color.clear
                .frame(
                    width: maxWidth,
                    height: min(maxHeight * 0.35, 300)
                )

            // Poster and info section
            HStack(spacing: .Spacing.space16) {
                // Poster skeleton
                SkeletonShape(cornerRadius: 12)
                    .frame(
                        width: 120,
                        height: 120 * 1.513
                    )

                VStack(alignment: .leading, spacing: .Spacing.space8) {
                    // Title skeleton
                    SkeletonShape()
                        .frame(width: 180, height: 24)

                    // Genres skeleton
                    HStack(spacing: 8) {
                        SkeletonShape()
                            .frame(width: 60, height: 16)
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 6, height: 6)
                        SkeletonShape()
                            .frame(width: 50, height: 16)
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 6, height: 6)
                        SkeletonShape()
                            .frame(width: 70, height: 16)
                    }

                    // Release date skeleton
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 16, height: 16)
                        SkeletonShape()
                            .frame(width: 100, height: 14)
                    }
                }
            }
            .padding(.horizontal, .Spacing.space24)
            .offset(y: -(120 * 1.513 / 2))
            .padding(.bottom, -(120 * 1.513) / 2)

            // Action buttons section
            HStack {
                // Trailer button skeleton
                SkeletonShape(cornerRadius: 8)
                    .frame(width: 100, height: 40)

                Spacer()

                // Duration skeleton
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 20, height: 20)
                    VStack(spacing: 2) {
                        SkeletonShape()
                            .frame(width: 50, height: 12)
                        SkeletonShape()
                            .frame(width: 40, height: 12)
                    }
                }

                Spacer()

                // Circle progress skeleton
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
            }
            .padding(.top, .Spacing.space24)
            .padding(.horizontal, .Spacing.space24)

            // Overview skeleton
            VStack(alignment: .leading, spacing: 8) {
                SkeletonShape()
                    .frame(height: 14)
                SkeletonShape()
                    .frame(height: 14)
                SkeletonShape()
                    .frame(height: 14)
                SkeletonShape()
                    .frame(width: 200, height: 14)
            }
            .padding(.horizontal, .Spacing.space24)
            .padding(.top, .Spacing.space24)

            // Button skeleton
            SkeletonShape(cornerRadius: 12)
                .frame(height: 48)
                .padding(.horizontal, .Spacing.space24)
                .padding(.top, .Spacing.space24)

            Spacer()
        }
    }
}

#Preview("Movie Detail Skeleton") {
    GeometryReader { geometry in
        MovieDetailSkeletonView(
            maxWidth: geometry.size.width,
            maxHeight: geometry.size.height
        )
        .background(Color.primaryBackground)
    }
}
