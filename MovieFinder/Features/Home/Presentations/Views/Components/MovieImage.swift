//
//  MovieImage.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 20/7/2568 BE.
//

import Kingfisher
import SwiftUI

struct MovieImage: View {
    var url: URL?

    private var cornerRadius: CGFloat {
        12
    }

    var body: some View {
        // 1. ใช้ GeometryReader เพื่ออ่านขนาดของพื้นที่ที่ได้รับ
        GeometryReader { geo in
            // 2. คำนวณความสูงตามสัดส่วนจากความกว้างที่ได้ (geo.size.width)
            let height = geo.size.width * 1.513

            ZStack {
                // --- ส่วนที่เป็นเงาเบลอๆ ด้านหลัง ---
                KFImage(url)
                    .placeholder {
                        SkeletonImageView()
                    }
                    .fade(duration: 0.5)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: height)
                    .cornerRadius(cornerRadius)
                    .blur(radius: 8)
                    .opacity(0.8)
                    .scaleEffect(1)
                    .offset(y: 2)

                // --- รูปภาพหลัก ---
                KFImage(url)
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: geo.size.width, height: height)
                    }
                    .fade(duration: 0.5)
                    .resizable()
                    .frame(width: geo.size.width, height: height)
                    .cornerRadius(cornerRadius)
            }
        }
        // 6. กำหนด Aspect Ratio ให้กับ GeometryReader ทั้งหมด
        // เพื่อให้มันจองพื้นที่ด้วยสัดส่วนที่ถูกต้องก่อนโหลดรูป
        .aspectRatio(1 / 1.513, contentMode: .fit)
    }
}

#Preview {
    let responseDTO: MovieResponseDTO = loadJson("testMovieList.json")
    let movieResponse = MovieResponseMapper.map(dto: responseDTO)

    if let firstMovie = movieResponse.results.first {
        MovieImage(url: firstMovie.posterURL)
            .padding(40)
            .background(Color.primaryBackground).frame(
                width: 300
            )
    } else {
        Text("ไม่พบข้อมูลหนังในไฟล์ JSON")
    }
}
