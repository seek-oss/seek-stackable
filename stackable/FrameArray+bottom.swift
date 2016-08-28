//  Copyright © 2016 SEEK. All rights reserved.
//

import UIKit

// CGRectProtocol is necessary to avoid compile error 'Element' constrained to non-protocol type
extension Array where Element: CGRectProtocol {
    var bottom: CGFloat {
        var bottom: CGFloat = 0.0
        for frame in self {
            bottom = max(bottom, frame.bottom)
        }
        return bottom
    }
}