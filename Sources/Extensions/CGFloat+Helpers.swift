//  Copyright © 2021 SEEK Limited. All rights reserved.
//

import UIKit

extension CGFloat {
    var isNoIntrinsicMetric: Bool {
        return self == UIView.noIntrinsicMetric || self == .greatestFiniteMagnitude
    }
}
