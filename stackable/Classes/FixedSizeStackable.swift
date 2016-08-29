//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

class FixedSizeStackable: StackableItem {
    var view: UIView
    var size: CGSize
    
    init(view: UIView, size: CGSize) {
        self.view = view
        self.size = size
    }
    
    func heightForWidth(width: CGFloat) -> CGFloat {
        return self.size.height
    }
    
    var hidden: Bool {
        return view.hidden
    }
}
