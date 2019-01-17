//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

public protocol Stack: class, Stackable {
    var thingsToStack: [Stackable] { get }
    var spacing: CGFloat { get }
    var layoutMargins: UIEdgeInsets { get }
    var width: CGFloat? { get }
    func framesForLayout(_ width: CGFloat, origin: CGPoint) -> [CGRect]
}

extension Stack {
    public var isHidden: Bool {
        return (self.thingsToStack.filter({ !$0.isHidden }).count == 0)
    }
    
    func visibleThingsToStack() -> [Stackable] {
        return self.thingsToStack.filter({ !$0.isHidden })
    }
    
    fileprivate func viewsToLayout() -> [UIView] {
        var views: [UIView] = []
        let thingsToStack = self.visibleThingsToStack()
        for i in 0..<thingsToStack.count {
            let stackable = thingsToStack[i]
            if let stack = stackable as? Stack {
                let innerViews = stack.viewsToLayout()
                views.append(contentsOf: innerViews)
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
    
    public func layoutWithFrames(_ frames: [CGRect]) {
        let views = self.viewsToLayout()
        
        assert(frames.count == views.count, "layoutWithFrames could not be performed because of frame(\(frames.count)) / view(\(views.count)) count mismatch")
        
        if views.count == frames.count {
            for i in 0..<frames.count {
                views[i].frame = frames[i]
            }
        }
    }
    
    public func heightForFrames(_ frames: [CGRect]) -> CGFloat {
        return frames.bottom + self.layoutMargins.bottom
    }
    
    public func framesForLayout(_ width: CGFloat) -> [CGRect] {
        return self.framesForLayout(width, origin: CGPoint.zero)
    }
}
