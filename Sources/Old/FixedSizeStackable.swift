//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

open class FixedSizeStackable: OldStackableItem {
    let view: UIView
    let size: CGSize

    public init(
        view: UIView,
        size: CGSize
    ) {
        self.view = view
        self.size = size
    }

    public convenience init(
        view: UIView,
        width: CGFloat,
        height: CGFloat
    ) {
        self.init(
            view: view,
            size: CGSize(
                width: width,
                height: height
            )
        )
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
