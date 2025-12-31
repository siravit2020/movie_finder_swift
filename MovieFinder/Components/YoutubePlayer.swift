//
//  YoutubePlayer.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 28/7/2568 BE.
//

import SwiftUI
import WebKit
import YouTubeiOSPlayerHelper

struct YouTubePlayerView: View {
    let videoId: String

    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                YouTubePlayer(videoId: videoId).frame(height: 250)

            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }

        }

    }

}

private struct YouTubePlayer: UIViewRepresentable {

    // 1. ตัวแปรสำหรับรับ Video ID
    let videoId: String

    // 2. ฟังก์ชันนี้จะสร้างและคืนค่า YTPlayerView
    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        return playerView
    }

    // 3. ฟังก์ชันนี้จะถูกเรียกเมื่อ State ของ SwiftUI มีการเปลี่ยนแปลง
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        // โหลดวิดีโอด้วย ID ที่ได้รับ
        uiView.load(withVideoId: videoId)
    }
}

#Preview {
    YouTubePlayerView(videoId: "puFt8Otb3Ao", isPresented: .constant(true))
}
