//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

extension UIView {
    @available(*, deprecated, message: "Use fixed(_:) or fixed(width:,height:) instead")
    public func stackSize(_ size: CGSize) -> FixedSizeStackable {
        return FixedSizeStackable(view: self, size: size)
    }
    
    public func fixed(size: CGSize) -> FixedSizeStackable {
        return FixedSizeStackable(view: self, size: size)
    }
    
    public func fixed(width: CGFloat, height: CGFloat) -> FixedSizeStackable {
        return FixedSizeStackable(view: self, width: width, height: height)
    }
    
    public func fixed(width: CGFloat) -> FixedSizeStackable {
        return FixedSizeStackable(view: self, width: width)
    }
    
    public func fixed(height: CGFloat) -> FixedSizeStackable {
        return FixedSizeStackable(view: self, height: height)
    }
}
