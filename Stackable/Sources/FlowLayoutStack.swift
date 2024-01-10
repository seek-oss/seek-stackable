//  Copyright © 2024 SEEK. All rights reserved.
//
import UIKit

open class FlowLayoutStack: Stack {
    public var thingsToStack: [Stackable]
    public var spacing: CGFloat
    public var lineSpacing: CGFloat
    // layoutMargins have not yet been implemented
    public var layoutMargins: UIEdgeInsets = .zero
    public var width: CGFloat?
    private var itemSpacing: CGFloat {
        spacing
    }
    
    public init(
        itemSpacing: CGFloat = 0.0,
        lineSpacing: CGFloat = 0.0,
        width: CGFloat? = nil,
        thingsToStack: [Stackable]
    ) {
        self.spacing = itemSpacing
        self.lineSpacing = lineSpacing
        self.layoutMargins = .zero
        self.width = width
        self.thingsToStack = thingsToStack
    }
    
    public convenience init(
        itemSpacing: CGFloat = 0.0,
        lineSpacing: CGFloat = 0.0,
        width: CGFloat? = nil,
        thingsToStack: () -> [Stackable]
    ) {
        self.init(
            itemSpacing: itemSpacing,
            lineSpacing: lineSpacing,
            width: width,
            thingsToStack: thingsToStack()
        )
    }
    
    open func framesForLayout(_ width: CGFloat, origin: CGPoint) -> [CGRect] {
        var frames: [CGRect] = []
        var currentY = origin.y
        var currentX = origin.x

        func moveToNextRow() {
            currentX = 0
            currentY = frames.reduce(0) { result, rect in
                max(
                    result,
                    rect.origin.y + rect.size.height
                )
            } + lineSpacing
        }
        
        for stackable in self.visibleThingsToStack() {
            let stackableWidth = getWidth(
                for: stackable,
                width: width
            )
                            
            if currentX + stackableWidth > width {
                moveToNextRow()
            }
            
            if let stack = stackable as? Stack {
                frames.append(
                    contentsOf: stack.framesForLayout(
                        (width - currentX),
                        origin: .init(
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

            currentX += stackableWidth + itemSpacing
        }

        return frames
    }
    
    private func getWidth(for stackable: Stackable, width: CGFloat) -> CGFloat {
        return if let stackableItem = stackable as? StackableItem {
            min(
                stackableItem.intrinsicContentSize.width,
                width
            )
        } else if let fixedSizeStack = stackable as? Stack, let stackWidth = fixedSizeStack.width {
            stackWidth
        } else {
           stackable.intrinsicContentSize.width
        }
    }
    
    public var intrinsicContentSize: CGSize {
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
}
