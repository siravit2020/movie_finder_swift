//
//  Avatar.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 18/7/2568 BE.
//

import Kingfisher
import SwiftUI

struct AppIconCircle: View {

    @GestureState private var isDetectingLongPress = false
    @GestureState private var isPressing = false

    var body: some View {
        Image("AppIconImage")
            .resizable()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(
                    LinearGradient(
                        colors: [.orange, .primaryAccent],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
                .shadow(color: .primaryAccent, radius: isPressing ? 10 : 0)
            }
            .scaleEffect(isPressing ? 1.2 : 1)
            .animation(.easeInOut(duration: 1), value: isPressing)
            .gesture(
                LongPressGesture(minimumDuration: 0.3)
                    .updating($isPressing) {
                        currentState,
                        gestureState,
                        transaction in
                        gestureState = currentState
                    }
            )
    }
}

#Preview {
    AppIconCircle()
}
