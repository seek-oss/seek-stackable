//  Copyright © 2021 SEEK Limited. All rights reserved.
//

import UIKit

public protocol StackableItemProtocol: UIView {
    func heightForWidth(_ width: CGFloat) -> CGFloat
}
