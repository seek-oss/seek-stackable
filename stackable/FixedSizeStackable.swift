//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

open class FixedSizeStackable: StackableItem {
    var view: UIView
    var size: CGSize
    
    public init(view: UIView, size: CGSize) {
        self.view = view
        self.size = size
    }
    
    open func heightForWidth(_ width: CGFloat) -> CGFloat {
        return self.size.height
    }
    
    open var isHidden: Bool {
        return view.isHidden
    }
}
