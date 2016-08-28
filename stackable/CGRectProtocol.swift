//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

protocol CGRectProtocol {
    var origin: CGPoint { get }
    var size: CGSize { get }
}

extension CGRectProtocol {
    var bottom: CGFloat {
        return self.origin.y + self.size.height
    }
}

extension CGRect: CGRectProtocol {
    
}
