//  Copyright © 2021 SEEK Limited. All rights reserved.
//

import UIKit

extension UILabel: StackableItemProtocol {
    public func heightForWidth(_ width: CGFloat) -> CGFloat {
        return self.sizeThatFits(
            CGSize(
                width: width,
                height: CGFloat.greatestFiniteMagnitude
            )
        ).height
    }
}
