//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

class VStack: Stack  {
    let thingsToStack: [Stackable]
    let spacing: CGFloat
    let layoutMargins: UIEdgeInsets
    
    init(spacing: CGFloat = 0.0, layoutMargins: UIEdgeInsets = UIEdgeInsetsZero, thingsToStack: [Stackable]) {
        self.spacing = spacing
        self.layoutMargins = layoutMargins
        self.thingsToStack = thingsToStack
    }
    
    func framesForLayout(width: CGFloat, origin: CGPoint) -> [CGRect] {
        var origin = origin
        var width = width
        if layoutMargins != UIEdgeInsetsZero {
            origin.x = layoutMargins.left
            origin.y = layoutMargins.top
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
                frames.appendContentsOf(innerFrames)
                y = frames.bottom
            } else if let item = stackable as? StackableItem {
                let height = item.heightForWidth(width)
                let frame = CGRectMake(origin.x, y, width, height)
                frames.append(frame)
                y += height
            }
        }
        return frames
    }
}

