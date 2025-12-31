//
//  HeaderSection.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 9/12/2568 BE.
//

import SwiftUI

struct HeaderSection<Destination: View>: View {
    var text: String
    var onSeeMore: () -> Destination

    var body: some View {
        HStack {
            Text(text).title1Style()
            Spacer()
            NavigationLink("See more", destination: onSeeMore())
                .calloutStyle()
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .conditionalGlassEffect(.clear)

        }
        .padding(.horizontal, .Spacing.space24)

    }
}

#Preview {
    HeaderSection(text: "Popular Movies") {
        Text("See More Tapped")
    }.background(.black)
}
