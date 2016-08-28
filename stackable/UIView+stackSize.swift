//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

extension UIView {
    func stackSize(size: CGSize) -> FixedSizeStackable {
        return FixedSizeStackable(view: self, size: size)
    }
}
