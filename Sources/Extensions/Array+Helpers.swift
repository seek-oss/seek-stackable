//  Copyright © 2021 SEEK Limited. All rights reserved.
//

import Foundation

extension Array {
    func stableSorted(
        by areInIncreasingOrder: (Element, Element) throws -> Bool
    ) rethrows -> [Element] {
        return try enumerated()
            .sorted { (lhs, rhs) -> Bool in
                try areInIncreasingOrder(lhs.element, rhs.element) || lhs.offset < rhs.offset
            }
            .map { $0.element }
    }
}
