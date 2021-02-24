//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

extension UILabel: StackableItem {
    public func heightForWidth(_ width: CGFloat) -> CGFloat {
        return self.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
            .height
    }
}
