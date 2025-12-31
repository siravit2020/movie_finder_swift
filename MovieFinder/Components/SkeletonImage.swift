//
//  SkeletonImage.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 27/7/2568 BE.
//

import SwiftUI

struct SkeletonImageView: View {
    @State private var isAnimating = false

    var body: some View {
        Rectangle()
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

#Preview {
    SkeletonImageView().frame(
        width: 200,
        height: 100,
    )
}
