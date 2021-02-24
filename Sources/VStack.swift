//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

open class VStack: Stack {
    public let thingsToStack: [StackableProtocol]
    public let spacing: CGFloat
    public let layoutMargins: UIEdgeInsets
    public let width: CGFloat?

    public init(
        spacing: CGFloat = 0.0,
        layoutMargins: UIEdgeInsets = .zero,
        thingsToStack: [StackableProtocol],
        width: CGFloat? = nil
    ) {
        self.spacing = spacing
        self.layoutMargins = layoutMargins
        self.thingsToStack = thingsToStack
        self.width = width
    }

    public convenience init(
        spacing: CGFloat = 0.0,
        layoutMargins: UIEdgeInsets = .zero,
        width: CGFloat? = nil,
        thingsToStack: () -> [StackableProtocol]
    ) {
        self.init(
            spacing: spacing,
            layoutMargins: layoutMargins,
            thingsToStack: thingsToStack(),
            width: width
        )
    }

    open func framesForLayout(_ width: CGFloat, origin: CGPoint) -> [CGRect] {
        var origin = origin
        var width = width
        if layoutMargins != .zero {
            origin.x += layoutMargins.left
            origin.y += layoutMargins.top
            width -= (layoutMargins.left + layoutMargins.right)
        }
        var frames: [CGRect] = []
        var y: CGFloat = origin.y
        self.visibleThingsToStack()
            .forEach { stackable in
                if let stack = stackable as? Stack {
                    let innerFrames = stack.framesForLayout(
                        width,
                        origin: CGPoint(x: origin.x, y: y)
                    )
                    frames.append(contentsOf: innerFrames)
                    y = frames.maxY
                } else if let item = stackable as? StackableItem {
                    let itemHeight = item.heightForWidth(width)
                    let itemWidth = min(width, item.intrinsicContentSize.width)
                    let frame = CGRect(x: origin.x, y: y, width: itemWidth, height: itemHeight)
                    frames.append(frame)
                    y += itemHeight
                }
                y += self.spacing
            }
        return frames
    }

    public var intrinsicContentSize: CGSize {
        let items = visibleThingsToStack()

        guard !items.isEmpty else { return .zero }

        // width
        let intrinsicWidth =
            items.reduce(0, { max($0, $1.intrinsicContentSize.width) })
            + layoutMargins.horizontalInsets

        // height
        let totalHeightOfItems = items.reduce(0, { $0 + $1.intrinsicContentSize.height })
        let totalVerticalSpacing = max(CGFloat(items.count) - 1, 0) * spacing
        let intrinsicHeight =
            totalHeightOfItems + totalVerticalSpacing + layoutMargins.verticalInsets

        return CGSize(width: intrinsicWidth, height: intrinsicHeight)
    }
}
