//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

protocol StackableItem: Stackable {
    func heightForWidth(width: CGFloat) -> CGFloat    
}