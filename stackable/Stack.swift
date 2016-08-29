//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

protocol Stack: class, Stackable {
    var thingsToStack: [Stackable] { get }
    var spacing: CGFloat { get }
    var layoutMargins: UIEdgeInsets { get }
    func framesForLayout(width: CGFloat, origin: CGPoint) -> [CGRect]
}

extension Stack {
    var hidden: Bool {
        return (self.thingsToStack.filter({ !$0.hidden }).count == 0)
    }
    
    func visibleThingsToStack() -> [Stackable] {
        return self.thingsToStack.filter({ !$0.hidden })
    }

    private func viewsToLayout() -> [UIView] {
        var views: [UIView] = []
        let thingsToStack = self.visibleThingsToStack()
        for i in 0..<thingsToStack.count {
            let stackable = thingsToStack[i]
            if let stack = stackable as? Stack {
                let innerViews = stack.viewsToLayout()
                views.appendContentsOf(innerViews)
            } else {
                if let view = stackable as? UIView {
                    views.append(view)
                } else if let fixedSizeStackable = stackable as? FixedSizeStackable {
                    views.append(fixedSizeStackable.view)
                }
            }
        }
        return views
    }
    
    func layoutWithFrames(frames: [CGRect]) {
        let views = self.viewsToLayout()

        assert(frames.count == views.count, "layoutWithFrames could not be performed because of frame(\(frames.count)) / view(\(views.count)) count mismatch")
        
        if views.count == frames.count {
            for i in 0..<frames.count {
                views[i].frame = frames[i]
            }
        }
    }

    func heightForFrames(frames: [CGRect]) -> CGFloat {
        return frames.bottom + self.layoutMargins.bottom
    }

    func framesForLayout(width: CGFloat) -> [CGRect] {
        return self.framesForLayout(width, origin: CGPointZero)
    }
}