//
//  AccountSection.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 9/12/2568 BE.
//

import SwiftUI

struct AccountSection: View {
    @AppStorage("isDarkMode") private var isDarkMode = true

    var body: some View {
        HStack {
            HStack {
                Avatar(imageURL: "https://picsum.photos/200")
                    .padding(.trailing, .Spacing.space8, )
                VStack(
                    alignment: HorizontalAlignment.leading,
                    spacing: .Spacing.space4
                ) {
                    Text("Welcome back").title2Style().fontWeight(
                        .regular
                    )
                    Text("Siravit").headlineStyle()
                }
            }
            Spacer()

            Image(
                systemName: isDarkMode ? "moon.fill" : "sun.max.fill"
            )
            .resizable()
            .frame(width: 20, height: 20)
            .padding(.Spacing.space8)
            .clipShape(Circle())
            .foregroundStyle(
                isDarkMode ? .yellow : .blue
            )
            .onTapGesture {
                isDarkMode.toggle()
            }
            .conditionalGlassEffect(shape: Circle())
        }.padding(.horizontal, .Spacing.space24).padding(
            .vertical,
            .Spacing.space24
        )
    }
}

#Preview {
    AccountSection()
}
