//
//  FlowLayout.swift
//  MovieFinder
//
//  Created by Siravit Pichphol on 27/8/2568 BE.
//

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height =
            rows.reduce(0) { $0 + $1.maxHeight } + CGFloat(rows.count - 1)
            * spacing
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY

        for row in rows {
            var x = bounds.minX
            for subview in row.subviews {
                subview.place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(
                        subview.sizeThatFits(.unspecified)
                    )
                )
                x += subview.sizeThatFits(.unspecified).width + spacing
            }
            y += row.maxHeight + spacing
        }
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews)
        -> [Row]
    {
        var rows: [Row] = []
        var currentRow = Row()

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentRow.width + size.width > (proposal.width ?? 0)
                && !currentRow.subviews.isEmpty
            {
                rows.append(currentRow)
                currentRow = Row()
            }
            currentRow.add(subview: subview, size: size)
        }

        if !currentRow.subviews.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }

    private struct Row {
        var subviews: [LayoutSubview] = []
        var width: CGFloat = 0
        var maxHeight: CGFloat = 0

        mutating func add(subview: LayoutSubview, size: CGSize) {
            subviews.append(subview)
            width += size.width
            maxHeight = max(maxHeight, size.height)
        }
    }
}
