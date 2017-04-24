//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

public protocol StackableItem: Stackable {
    func heightForWidth(_ width: CGFloat) -> CGFloat    
}
