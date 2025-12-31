//
//  GlassEffectModifier.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 12/12/2568 BE.
//

import SwiftUI

struct GlassEffectModifier: ViewModifier {
    var shape: AnyShape
    var displayMode: GlassEffectDisplayMode
    
    init(
        shape: some Shape = Capsule(),
        displayMode: GlassEffectDisplayMode = .automatic
    ) {
        self.shape = AnyShape(shape)
        self.displayMode = displayMode
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            switch displayMode {
            case .automatic:
                content.glassEffect()
            case .clear:
                content.glassEffect(.clear)
            }
        } else {
            content
                .background(.ultraThinMaterial, in: shape)
        }
    }
}

enum GlassEffectDisplayMode {
    case automatic
    case clear
}

extension View {
    func conditionalGlassEffect(
        _ displayMode: GlassEffectDisplayMode = .automatic,
        shape: some Shape = Capsule()
    ) -> some View {
        modifier(GlassEffectModifier(shape: shape, displayMode: displayMode))
    }
}
