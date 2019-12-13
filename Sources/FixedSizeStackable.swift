//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

open class FixedSizeStackable: StackableItem {
    var view: UIView
    var width: CGFloat?
    var height: CGFloat?
    
    var size: CGSize {
        let width = self.width ?? view.intrinsicContentSize.width
        let height = self.height ?? view.intrinsicContentSize.height
        return CGSize(width: width, height: height)
    }
    
    public init(view: UIView, width: CGFloat, height: CGFloat) {
        self.view = view
        self.width = width
        self.height = height
    }
    
    public init(view: UIView, width: CGFloat) {
        self.view = view
        self.width = width
    }
    
    public init(view: UIView, height: CGFloat) {
        self.view = view
        self.height = height
    }
    
    public convenience init(view: UIView, size: CGSize) {
        self.init(view: view, width: size.width, height: size.height)
    }
    
    open func heightForWidth(_ width: CGFloat) -> CGFloat {
        return size.height
    }
    
    open var isHidden: Bool {
        return view.isHidden
    }
    
    public var intrinsicContentSize: CGSize {
        return size
    }
}
