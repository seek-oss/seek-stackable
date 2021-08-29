//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

public protocol OldStackableItem: StackableProtocol {
    func heightForWidth(_ width: CGFloat) -> CGFloat
}
