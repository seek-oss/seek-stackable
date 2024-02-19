//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

open class HStack: Stack {
    public enum Distribution: Equatable {
        case fillEqually
        case fill
    }
    public let spacing: CGFloat
    public let distribution: Distribution
    public let layoutMargins: UIEdgeInsets
    public let thingsToStack: [Stackable]
    public let width: CGFloat?

    public init(
        spacing: CGFloat = 0.0,
        distribution: Distribution = .fillEqually,
        layoutMargins: UIEdgeInsets = .zero,
        thingsToStack: [Stackable],
        width: CGFloat? = nil
    ) {
        self.spacing = spacing
        self.distribution = distribution
        self.layoutMargins = layoutMargins
        self.thingsToStack = thingsToStack
        self.width = width
    }
    
    public convenience init(
        spacing: CGFloat = 0.0,
        distribution: Distribution = .fillEqually,
        layoutMargins: UIEdgeInsets = .zero,
        width: CGFloat? = nil,
        thingsToStack: () -> [Stackable]
    ) {
        self.init(
            spacing: spacing,
            distribution: distribution,
            layoutMargins: layoutMargins,
            thingsToStack: thingsToStack(),
            width: width
        )
    }
    
    open func framesForLayout(_ width: CGFloat, origin: CGPoint) -> [CGRect] {
        // TODO: add adjustments for layoutMargins (not currently needed so okay to defer)

        var frames: [CGRect] = []
        var currentX = origin.x
        let currentY = origin.y
        
        for stackable in visibleThingsToStack() {
            let stackableWidth = getWidth(
                for: stackable,
                width: width,
                currentX: currentX
            )
            
            if let stack = stackable as? Stack {
                frames.append(
                    contentsOf: stack.framesForLayout(
                        stackableWidth,
                        origin: CGPoint(
                            x: currentX,
                            y: currentY
                        )
                    )
                )
            } else if let item = stackable as? StackableItem {
                frames.append(
                    .init(
                        x: currentX,
                        y: currentY,
                        width: stackableWidth,
                        height: item.heightForWidth(stackableWidth)
                    )
                )
            }
            
            currentX += stackableWidth + spacing
        }
        
        return frames
    }
    
    public var intrinsicContentSize: CGSize {
        // TODO: add adjustments for layoutMargins (not currently needed so okay to defer)
        
        let items = visibleThingsToStack()
        
        guard !items.isEmpty else { return .zero }
        
        // width
        let totalWidthOfItems = items.reduce(0, { $0 + $1.intrinsicContentSize.width })
        let totalHorizontalSpacing = max(CGFloat(items.count) - 1, 0) * spacing
        let intrinsicWidth = totalWidthOfItems + totalHorizontalSpacing
        
        // height
        let intrinsicHeight = items.reduce(0, { max($0, $1.intrinsicContentSize.height) })
        
        return CGSize(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    // MARK: helpers
    
    private func getWidth(
        for stackable: Stackable,
        width: CGFloat,
        currentX: Double
    ) -> CGFloat {
        let thingsToStack = visibleThingsToStack()
        
        if let fixedSizeStackable = stackable as? FixedSizeStackable {
            return fixedSizeStackable.size.width
        } else if let fixedSizeStack = stackable as? Stack, let stackWidth = fixedSizeStack.width {
            return  stackWidth
        } else if let item = stackable as? StackableItem, distribution == .fill {
            let itemWidth = item.intrinsicContentSize.width
            let widthBalance = max(
                width - currentX,
                width - (currentX - width)
            )
            
            if widthBalance <= 0 {
                return 0
            } else {
                return itemWidth <= widthBalance ? itemWidth : widthBalance
            }
        } else {
            return widthForNonFixedSizeStackables(
                width,
                thingsToStack: thingsToStack
            )
        }
    }

    private  func widthForNonFixedSizeStackables(_ width: CGFloat, thingsToStack: [Stackable]) -> CGFloat {
        let fixedWidths = thingsToStack
            .filter {
                $0 is FixedSizeStackable || ($0 as? Stack)?.width != nil
            }
            .map { (stackable) -> CGFloat in
                if let stack = stackable as? Stack, let stackWidth = stack.width {
                    return stackWidth
                } else if let fixedSizeStackable = stackable as? FixedSizeStackable {
                    return fixedSizeStackable.size.width
                } else {
                    return 0
                }
            }
        
        let totalFixedWidth = fixedWidths.reduce(0.0, +)
        let totalNonFixedWidth = width - totalFixedWidth - (((CGFloat(thingsToStack.count) - 1) * self.spacing))
        let numberOfStackablesWithNonFixedWidth = thingsToStack.count - fixedWidths.count
        return floor(totalNonFixedWidth / CGFloat(numberOfStackablesWithNonFixedWidth))
    }
}
