//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

public protocol StackableItem: StackableProtocol {
    func heightForWidth(_ width: CGFloat) -> CGFloat
}
