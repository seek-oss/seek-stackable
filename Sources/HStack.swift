//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

open class HStack: Stack {
    public enum Distribution: Equatable {
        case fillEqually
        case fill
    }
    public enum Alignment: Equatable {
        case top
        case bottom
    }
    public let spacing: CGFloat
    public let distribution: Distribution
    public let alignment: Alignment
    public let layoutMargins: UIEdgeInsets
    public let thingsToStack: [Stackable]
    public let width: CGFloat?

    public init(
        spacing: CGFloat = 0.0,
        distribution: Distribution = .fillEqually,
        alignment: Alignment = .top,
        layoutMargins: UIEdgeInsets = .zero,
        thingsToStack: [Stackable],
        width: CGFloat? = nil
    ) {
        self.spacing = spacing
        self.distribution = distribution
        self.layoutMargins = layoutMargins
        self.thingsToStack = thingsToStack
        self.width = width
        self.alignment = alignment
    }
    
    public convenience init(
        spacing: CGFloat = 0.0,
        distribution: Distribution = .fillEqually,
        alignment: Alignment = .top,
        layoutMargins: UIEdgeInsets = .zero,
        width: CGFloat? = nil,
        thingsToStack: () -> [Stackable]
    ) {
        self.init(
            spacing: spacing,
            distribution: distribution,
            alignment: alignment,
            layoutMargins: layoutMargins,
            thingsToStack: thingsToStack(),
            width: width
        )
    }
    
    open func framesForLayout(_ width: CGFloat, origin: CGPoint) -> [CGRect] {
        // TODO: add adjustments for layoutMargins (not currently needed so okay to defer)

        var frameGroups: [[CGRect]] = []
        var currentX = origin.x
        let currentY = origin.y
        
        for stackable in visibleThingsToStack() {
            let stackableWidth = getWidth(
                for: stackable,
                width: width,
                currentX: currentX,
                frames: frameGroups.flatMap { $0 }
            )

            if let stack = stackable as? Stack {
                frameGroups.append(stack.framesForLayout(
                    stackableWidth,
                    origin: CGPoint(
                        x: currentX,
                        y: currentY
                    )
                ))
            } else if let item = stackable as? StackableItem {
                frameGroups.append([
                    .init(
                        x: currentX,
                        y: currentY,
                        width: stackableWidth,
                        height: item.heightForWidth(stackableWidth)
                    )
                ])
            }

            currentX += stackableWidth + spacing
        }
        
        switch alignment {
        case .top:
            return frameGroups.flatMap { $0 }
        case .bottom:
            let frameGroupsMaxHeight = frameGroups.flatMap { $0 }.maxY - origin.y
            var frames: [CGRect] = []

            for group in frameGroups {
                let groupHeight = group.maxY - origin.y

                if groupHeight < frameGroupsMaxHeight {
                    let frameYOffset = frameGroupsMaxHeight - groupHeight

                    group.forEach {
                        var frame = $0
                        frame.origin.y += frameYOffset
                        frames.append(
                            frame
                        )
                    }
                } else {
                    frames.append(contentsOf: group)
                }
            }

            return frames
        }
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
        currentX: Double,
        frames: [CGRect]
    ) -> CGFloat {
        switch distribution {
        case .fill:
            getWidthForDistributionFill(
                for: stackable,
                width: width,
                currentX: currentX,
                frames: frames
            )
        case .fillEqually:
            getWidthForDistributionFillEqually(
                for: stackable,
                width: width
            )
        }
    }

    private func getWidthForDistributionFill(
        for stackable: Stackable,
        width: CGFloat,
        currentX: Double,
        frames: [CGRect]
    ) -> CGFloat {
        let existingItemXOffsetInCommonStack = if let firstFrame = frames.first {
            firstFrame.origin.x
        } else {
           CGFloat(0)
        }

        // If we have no frames we want to treat the current
        // x offset as being 0 so our calculations work when
        // an item is nested in a stack and when it is not
        //
        // currentX is the calculation passed in that contains
        // the width + any spacing that been configured
        let currentXOffset = if frames.isEmpty {
            CGFloat(0)
        } else {
            CGFloat(currentX)
        }

        // Calculate the relative X of the item positioned within the given width
        let relativeXOffsetInStack = currentXOffset - existingItemXOffsetInCommonStack

        if let fixedSizeStackable = stackable as? FixedSizeStackable {
            let itemWidth = min(
                fixedSizeStackable.size.width,
                max(width - relativeXOffsetInStack, 0)
            )

            #if DEBUG
                if itemWidth == 0 {
                    print("\(fixedSizeStackable) - is dropped from layout as it doesn't fit!")
                }
            #endif

            return itemWidth
        } else if let stack = stackable as? Stack {
            if let fixedSizeStackWidth = stack.width {
                return fixedSizeStackWidth
            } else {
                return min(
                    width - currentX,
                    stack.intrinsicContentSize.width
                )
            }
        }
        else if let item = stackable as? StackableItem {
            let itemWidth = min(
                item.intrinsicContentSize.width,
                max(width - relativeXOffsetInStack, 0)
            )

            #if DEBUG
                if itemWidth == 0 {
                    print("\(item) - is dropped from layout as it doesn't fit!")
                }
            #endif

            return itemWidth
        } else {
            return stackable.intrinsicContentSize.width
        }
    }
    
    private func getWidthForDistributionFillEqually(
        for stackable: Stackable,
        width: CGFloat
    ) -> CGFloat {
        return if let fixedSizeStackable = stackable as? FixedSizeStackable {
            fixedSizeStackable.size.width
        } else if let stack = stackable as? Stack, let fixedSizeStackWidth = stack.width {
            fixedSizeStackWidth
        } else {
            widthForNonFixedSizeStackables(
                width,
                thingsToStack: visibleThingsToStack()
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
