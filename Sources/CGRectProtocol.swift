//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

public protocol CGRectProtocol {
    var origin: CGPoint { get }
    var size: CGSize { get }
    var maxY: CGFloat { get }
}

extension CGRect: CGRectProtocol {
    
}
