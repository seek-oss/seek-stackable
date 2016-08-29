//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

extension UILabel: StackableItem {
    public func heightForWidth(width: CGFloat) -> CGFloat {
        return self.sizeThatFits(CGSizeMake(width, 9999)).height
    }
}
