//  Copyright © 2021 SEEK Limited. All rights reserved.
//

import UIKit

extension HStack {
    struct LayoutInfo: Hashable {
        let id = UUID()
        let view: UIView
        let item: StackableItemProtocol
        let intrinsicContentSize: CGSize
        let contentHuggingPriority: UILayoutPriority
        let contentCompressionResistancePriority: UILayoutPriority

        var hasNoInstrincWidth: Bool {
            return intrinsicContentSize.width.isNoIntrinsicMetric
        }

        var hasIntrinsicWidth: Bool {
            return !hasNoInstrincWidth
        }

        init(
            view: UIView,
            item: StackableItemProtocol,
            intrinsicContentSize: CGSize,
            contentHuggingPriority: UILayoutPriority,
            contentCompressionResistancePriority: UILayoutPriority
        ) {
            self.view = view
            self.item = item
            self.intrinsicContentSize = intrinsicContentSize
            self.contentHuggingPriority = contentHuggingPriority
            self.contentCompressionResistancePriority = contentCompressionResistancePriority
        }

        init(
            item: StackableItemProtocol
        ) {
            self.view = item
            self.item = item
            self.intrinsicContentSize = item.intrinsicContentSize
            self.contentHuggingPriority = item.contentHuggingPriority(
                for: .horizontal
            )
            self.contentCompressionResistancePriority = item.contentCompressionResistancePriority(
                for: .horizontal
            )
        }

        static func == (
            lhs: HStack.LayoutInfo,
            rhs: HStack.LayoutInfo
        ) -> Bool {
            lhs.id == rhs.id
                && lhs.view == rhs.view
                && lhs.intrinsicContentSize == rhs.intrinsicContentSize
                && lhs.contentHuggingPriority == rhs.contentHuggingPriority
                && lhs.contentCompressionResistancePriority
                    == rhs.contentCompressionResistancePriority
        }

        func hash(
            into hasher: inout Hasher
        ) {
            hasher.combine(id)
        }
    }

    class SizeCalculationItem: Hashable {
        let info: LayoutInfo
        var width: CGFloat {
            didSet {
                height = info.item.heightForWidth(width)
            }
        }
        private(set) var height: CGFloat

        init(
            info: LayoutInfo
        ) {
            self.info = info
            self.width = info.intrinsicContentSize.width
            self.height = info.item.heightForWidth(width)
        }

        static func == (
            lhs: HStack.SizeCalculationItem,
            rhs: HStack.SizeCalculationItem
        ) -> Bool {
            lhs.info == rhs.info && lhs.width == rhs.width
        }

        func hash(
            into hasher: inout Hasher
        ) {
            hasher.combine(info)
        }
    }
}
