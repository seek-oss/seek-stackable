//  Copyright © 2021 SEEK Limited. All rights reserved.
//

import UIKit

extension CGRect {
    enum VerticalAnchor {
        case top
        case center
        case bottom
    }

    enum HorizontalAnchor {
        case leading
        case center
        case trailing
    }

    mutating func set(
        width: CGFloat,
        anchoredTo anchor: HorizontalAnchor
    ) {
        switch anchor {
        case .leading:
            size.width = width
        case .center:
            let inset = (size.width - width) / 2
            self = insetBy(dx: inset, dy: 0)
        case .trailing:
            origin.x = maxX - width
            size.width = width
        }
    }

    func bySetting(
        width: CGFloat,
        anchoredTo anchor: HorizontalAnchor
    ) -> CGRect {
        var frame = self
        frame.set(
            width: width,
            anchoredTo: anchor
        )
        return frame
    }

    mutating func set(
        height: CGFloat,
        anchoredTo anchor: VerticalAnchor
    ) {
        switch anchor {
        case .top:
            size.height = height
        case .center:
            let inset = (size.height - height) / 2
            self = insetBy(dx: 0, dy: inset)
        case .bottom:
            origin.y = maxY - height
            size.height = height
        }
    }

    func bySetting(
        height: CGFloat,
        anchoredTo anchor: VerticalAnchor
    ) -> CGRect {
        var frame = self
        frame.set(
            height: height,
            anchoredTo: anchor
        )
        return frame
    }
}
