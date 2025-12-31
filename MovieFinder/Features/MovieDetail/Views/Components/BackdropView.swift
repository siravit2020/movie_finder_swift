//
//  BackdropView.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 9/12/2568 BE.
//

import Kingfisher
import SwiftUI

struct BackdropView: View {
    var backdropURL: URL? = nil
    var maxHeight: CGFloat = 250
    var maxWidth: CGFloat = .infinity

    var body: some View {

        ZStack(alignment: .bottom) {
            KFImage(backdropURL)
                .placeholder {
                    SkeletonImageView()
                }
                .fade(duration: 0.5)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: maxWidth,
                    height: maxHeight * 0.3,

                )
                .clipped()

            LinearGradient(
                colors: [.primaryBackground, .clear],
                startPoint: .bottom,
                endPoint: .top
            ).frame(
                height: maxHeight * 0.1
            )
        }

    }
}

#Preview {
    BackdropView(backdropURL: URL(string: "https://picsum.photos/1066/600"))
}
