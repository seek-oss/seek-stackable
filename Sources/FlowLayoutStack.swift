//  Copyright © 2024 SEEK. All rights reserved.
//
import UIKit

import UIKit

open class FlowLayoutStack: HStack {
    let lineSpacing: CGFloat
    private var itemSpacing: CGFloat {
        spacing
    }
    
    public init(
        itemSpacing: CGFloat = 0.0,
        lineSpacing: CGFloat = 0.0,
        width: CGFloat? = nil,
        thingsToStack: [Stackable]
    ) {
        self.lineSpacing = lineSpacing
        
        super.init(
            spacing: itemSpacing,
            layoutMargins: .zero,
            thingsToStack: thingsToStack,
            width: width
        )
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
    
    open override func framesForLayout(_ width: CGFloat, origin: CGPoint) -> [CGRect] {
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
}
