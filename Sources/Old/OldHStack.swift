//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

open class OldHStack: OldStack {
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
        let thingsToStack = visibleThingsToStack()
        var frames: [CGRect] = []

        var x = origin.x + layoutMargins.left
        let y = origin.y + layoutMargins.top
        let nonFixedWidth = widthForNonFixedSizeStackables(
            width,
            thingsToStack: thingsToStack
        )

        thingsToStack.forEach { stackable in
            let stackableWidth: CGFloat
            if let fixedSizeStackable = stackable as? FixedSizeStackable {
                stackableWidth = fixedSizeStackable.size.width
            } else if let fixedSizeStack = stackable as? OldStack,
                let stackWidth = fixedSizeStack.width
            {
                stackableWidth = stackWidth
            } else {
                stackableWidth = nonFixedWidth
            }

            if let stack = stackable as? OldStack {
                let innerFrames = stack.framesForLayout(
                    stackableWidth,
                    origin: CGPoint(x: x, y: y)
                )
                frames.append(contentsOf: innerFrames)
                x += stackableWidth
            } else if let item = stackable as? OldStackableItem {
                let stackableHeight = item.heightForWidth(stackableWidth)
                let frame = CGRect(x: x, y: y, width: stackableWidth, height: stackableHeight)
                frames.append(frame)
                x += stackableWidth
            }

            x += spacing
        }

        return frames
    }

    public var intrinsicContentSize: CGSize {
        let items = visibleThingsToStack()

        guard !items.isEmpty else { return .zero }

        let totalWidthOfItems = items.reduce(0, { $0 + $1.intrinsicContentSize.width })
        let totalHorizontalSpacing = max(CGFloat(items.count) - 1, 0) * spacing
        let intrinsicWidth = totalWidthOfItems + totalHorizontalSpacing

        let intrinsicHeight = items.reduce(0, { max($0, $1.intrinsicContentSize.height) })

        return CGSize(
            width: intrinsicWidth + layoutMargins.horizontalInsets,
            height: intrinsicHeight + layoutMargins.verticalInsets
        )
    }

    // MARK: helpers

    private func widthForNonFixedSizeStackables(
        _ width: CGFloat,
        thingsToStack: [StackableProtocol]
    ) -> CGFloat {
        let fixedWidths =
            thingsToStack
            .filter {
                $0 is FixedSizeStackable || ($0 as? OldStack)?.width != nil
            }
            .map { (stackable) -> CGFloat in
                if let stack = stackable as? OldStack, let stackWidth = stack.width {
                    return stackWidth
                } else if let fixedSizeStackable = stackable as? FixedSizeStackable {
                    return fixedSizeStackable.size.width
                } else {
                    return 0
                }
            }

        let totalFixedWidth = fixedWidths.reduce(0.0, +)
        let totalNonFixedWidth =
            width
            - layoutMargins.horizontalInsets
            - totalFixedWidth
            - (((CGFloat(thingsToStack.count) - 1) * spacing))
        let numberOfStackablesWithNonFixedWidth = thingsToStack.count - fixedWidths.count
        return floor(totalNonFixedWidth / CGFloat(numberOfStackablesWithNonFixedWidth))
    }
}
