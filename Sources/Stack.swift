//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

public protocol Stack: class, StackableProtocol {
    var thingsToStack: [StackableProtocol] { get }
    var spacing: CGFloat { get }
    var layoutMargins: UIEdgeInsets { get }
    var width: CGFloat? { get }
    func framesForLayout(_ width: CGFloat, origin: CGPoint) -> [CGRect]
}

extension Stack {
    public var isHidden: Bool {
        return self.thingsToStack.allSatisfy { $0.isHidden }
    }

    func visibleThingsToStack() -> [StackableProtocol] {
        return self.thingsToStack.filter({ !$0.isHidden })
    }

    fileprivate func viewsToLayout() -> [UIView] {
        return visibleThingsToStack()
            .flatMap { stackable -> [UIView] in
                if let stack = stackable as? Stack {
                    return stack.viewsToLayout()
                } else {
                    if let view = stackable as? UIView {
                        return [view]
                    } else if let fixedSizeStackable = stackable as? FixedSizeStackable {
                        return [fixedSizeStackable.view]
                    } else {
                        return []
                    }
                }
            }
    }

    public func layoutWithFrames(_ frames: [CGRect]) {
        let views = self.viewsToLayout()

        assert(
            frames.count == views.count,
            "layoutWithFrames could not be performed because of frame(\(frames.count)) / view(\(views.count)) count mismatch"
        )

        if views.count == frames.count {
            for i in 0..<frames.count {
                views[i].frame = frames[i]
            }
        }
    }

    public func heightForFrames(_ frames: [CGRect]) -> CGFloat {
        return frames.maxY + self.layoutMargins.bottom
    }

    public func framesForLayout(_ width: CGFloat) -> [CGRect] {
        return self.framesForLayout(width, origin: CGPoint.zero)
    }
}
