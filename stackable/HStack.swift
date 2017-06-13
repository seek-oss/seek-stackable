//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

open class HStack: Stack {
    open let thingsToStack: [Stackable]
    open let spacing: CGFloat
    open let layoutMargins: UIEdgeInsets
    open let width: CGFloat?
    
    public init(spacing: CGFloat = 0.0, layoutMargins: UIEdgeInsets = UIEdgeInsets.zero, thingsToStack: [Stackable], width: CGFloat? = nil) {
        self.spacing = spacing
        self.layoutMargins = layoutMargins
        self.thingsToStack = thingsToStack
        self.width = width
    }
    
    open func framesForLayout(_ width: CGFloat, origin: CGPoint) -> [CGRect] {
        // TODO: add adjustments for layoutMargins (not currently needed so okay to defer)
        
        let thingsToStack = self.visibleThingsToStack()
        var frames: [CGRect] = []
        
        var x = origin.x
        let y = origin.y
        let nonFixedWidth = self.widthForNonFixedSizeStackables(width, thingsToStack: thingsToStack)
        for i in 0..<thingsToStack.count {
            if i > 0 {
                x += self.spacing
            }
            
            let stackable = thingsToStack[i]
            let stackableWidth: CGFloat!
            if let fixedSizeStackable = stackable as? FixedSizeStackable {
                stackableWidth = fixedSizeStackable.size.width
            } else if let fixedSizeStack = stackable as? Stack, let stackWidth = fixedSizeStack.width {
                stackableWidth = stackWidth
            } else {
                stackableWidth = nonFixedWidth
            }
            
            if let stack = stackable as? Stack {
                let innerFrames = stack.framesForLayout(stackableWidth, origin: CGPoint(x: x, y: origin.y))
                frames.append(contentsOf: innerFrames)
                x += stackableWidth
            } else if let item = stackable as? StackableItem {
                let stackableHeight = item.heightForWidth(stackableWidth)
                let frame = CGRect(x: x, y: y, width: stackableWidth, height: stackableHeight)
                frames.append(frame)
                x += stackableWidth
            }
        }
        
        return frames
    }
    
    // MARK: helpers
    fileprivate func widthForNonFixedSizeStackables(_ width: CGFloat, thingsToStack: [Stackable]) -> CGFloat {
        let fixedWidths = thingsToStack.filter({
            $0 is FixedSizeStackable || ($0 as? Stack)?.width != nil
        }).map { (stackable) -> CGFloat in
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
        return  floor(totalNonFixedWidth / CGFloat(numberOfStackablesWithNonFixedWidth))
    }
}
