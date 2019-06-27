//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

open class VStack: Stack  {
    public let thingsToStack: [Stackable]
    public let spacing: CGFloat
    public let layoutMargins: UIEdgeInsets
    public let width: CGFloat?
    
    public init(spacing: CGFloat = 0.0, layoutMargins: UIEdgeInsets = UIEdgeInsets.zero, thingsToStack: [Stackable], width: CGFloat? = nil) {
        self.spacing = spacing
        self.layoutMargins = layoutMargins
        self.thingsToStack = thingsToStack
        self.width = width
    }
    
    public convenience init(spacing: CGFloat = 0.0, layoutMargins: UIEdgeInsets = UIEdgeInsets.zero, width: CGFloat? = nil, thingsToStack: () -> [Stackable]) {
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
        if layoutMargins != UIEdgeInsets.zero {
            origin.x += layoutMargins.left
            origin.y += layoutMargins.top
            width -= (layoutMargins.left + layoutMargins.right)
        }
        let thingsToStack = self.visibleThingsToStack()
        var frames: [CGRect] = []
        var y: CGFloat = origin.y
        for i in 0..<thingsToStack.count {
            if i > 0 {
                y += self.spacing
            }
            let stackable = thingsToStack[i]
            if let stack = stackable as? Stack {
                let innerFrames = stack.framesForLayout(width, origin: CGPoint(x: origin.x, y: y))
                frames.append(contentsOf: innerFrames)
                y = frames.bottom
            } else if let item = stackable as? StackableItem {
                let height = item.heightForWidth(width)
                let frame = CGRect(x: origin.x, y: y, width: width, height: height)
                frames.append(frame)
                y += height
            }
        }
        return frames
    }
}

