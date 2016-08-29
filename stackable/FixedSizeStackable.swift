//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

public class FixedSizeStackable: StackableItem {
    var view: UIView
    var size: CGSize
    
    init(view: UIView, size: CGSize) {
        self.view = view
        self.size = size
    }
    
    public func heightForWidth(width: CGFloat) -> CGFloat {
        return self.size.height
    }
    
    public var hidden: Bool {
        return view.hidden
    }
}
