//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

extension UIView {
    public func stackSize(_ size: CGSize) -> FixedSizeStackable {
        return FixedSizeStackable(view: self, size: size)
    }
}
