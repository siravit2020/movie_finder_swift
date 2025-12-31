//
//  CircleProgress.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 20/7/2568 BE.
//

import SwiftUI

struct CircleProgress: View {
    var value: Double
    var size: CGFloat = 32
    var enableBackground: Bool = true

    var body: some View {
        ZStack {
            // Background
            if enableBackground {
                Color.black.frame(
                    width: size + 9,
                    height: size + 9,
                ).clipShape(Circle())
            }

            // Background circle
            Circle()
                .stroke(
                    Color.gray.opacity(0.3),
                    lineWidth: 3
                )
                .frame(
                    width: size,
                    height: size
                )

            // Progress circle
            Circle()
                .trim(
                    from: 0,
                    to: value / 100.0
                )
                .stroke(
                    Color.green,
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .frame(
                    width: size,
                    height: size,
                )
                .rotationEffect(
                    .degrees(-90)
                )

            // Percentage text
            if enableBackground {
                Text(
                    "\(Int(value))%"
                )
                .foregroundStyle(.white)
                .captionStyle()
            } else {
                Text(
                    "\(Int(value))%"
                )
                .captionStyle()
            }
        }
    }
}

#Preview {
    CircleProgress(value: 80)
}
