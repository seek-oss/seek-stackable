//  Copyright © 2016 SEEK. All rights reserved.
//

import Foundation

// CGRectProtocol is necessary to avoid compile error 'Element' constrained to non-protocol type
extension Array where Element: CGRectProtocol {
    var maxY: CGFloat {
        return reduce(
            0,
            { (result, frame) -> CGFloat in
                return [result, frame.maxY].max() ?? result
            }
        )
    }
}
