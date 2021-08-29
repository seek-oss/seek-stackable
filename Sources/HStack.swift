//  Copyright © 2021 SEEK Limited. All rights reserved.
//

import Algorithms
import UIKit

open class HStack: UIView, StackableItemProtocol {
    public enum Alignment {
        case top
        case center
        case bottom
        case fill
    }

    public let spacing: CGFloat
    public let alignment: Alignment
    public let children: [StackableItemProtocol]

    private(set) var observations: [NSKeyValueObservation] = []

    public init(
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = .zero,
        alignment: Alignment = .fill,
        children: [StackableItemProtocol]
    ) {
        self.spacing = spacing
        self.alignment = alignment
        self.children = children

        super.init(frame: .zero)

        self.layoutMargins = layoutMargins

        observations = children.map {
            ($0 as UIView).observe(\.isHidden, options: [.new]) { [weak self] _, _ in
                self?.invalidateIntrinsicContentSize()
                self?.setNeedsLayout()
            }
        }

        children.forEach {
            addSubview($0)
        }
    }

    public required init?(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    open override var intrinsicContentSize: CGSize {
        let children = visibleChildren()

        guard !children.isEmpty else { return .zero }

        let infos = layoutInfo(for: children)

        let childHasNoIntrinsicWidth = infos.contains(
            where: { $0.intrinsicContentSize.width.isNoIntrinsicMetric }
        )
        let childHasNoIntrinsicHeight = infos.contains(
            where: { $0.intrinsicContentSize.height.isNoIntrinsicMetric }
        )

        let intrinsicWidth: CGFloat
        if childHasNoIntrinsicWidth {
            intrinsicWidth = UIView.noIntrinsicMetric
        } else {
            let totalWidthOfItems = infos.reduce(0) {
                $0 + $1.intrinsicContentSize.width
            }
            let totalHorizontalSpacing = max(CGFloat(children.count) - 1, 0) * spacing
            intrinsicWidth = totalWidthOfItems + totalHorizontalSpacing
        }

        let intrinsicHeight: CGFloat
        if childHasNoIntrinsicHeight {
            intrinsicHeight = UIView.noIntrinsicMetric
        } else {
            intrinsicHeight = infos.reduce(0) {
                max($0, $1.intrinsicContentSize.height)
            }
        }

        return CGSize(
            width: intrinsicWidth + layoutMargins.horizontal,
            height: intrinsicHeight + layoutMargins.vertical
        )
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let visibleChildren = visibleChildren()

        var x = bounds.origin.x + layoutMargins.left
        let y = bounds.origin.y + layoutMargins.top
        let width = bounds.width - layoutMargins.left - layoutMargins.right

        let totalSpacing = max(
            spacing * CGFloat(visibleChildren.count - 1),
            0
        )
        let totalItemWidth = max(
            width - totalSpacing,
            0
        )

        let infos = layoutInfo(
            for: visibleChildren
        )
        let items = sizeOfItems(
            for: infos,
            in: totalItemWidth
        )

        let totalHeight = height(from: items)

        items.forEach { item in
            let frame = CGRect(
                x: x,
                y: y,
                width: item.width,
                height: totalHeight
            )

            switch alignment {
            case .top:
                item.info.view.frame = frame.bySetting(
                    height: item.height,
                    anchoredTo: .top
                )
            case .center:
                item.info.view.frame = frame.bySetting(
                    height: item.height,
                    anchoredTo: .center
                )
            case .bottom:
                item.info.view.frame = frame.bySetting(
                    height: item.height,
                    anchoredTo: .bottom
                )
            case .fill:
                item.info.view.frame = frame
            }

            x += item.width + spacing
        }

        frame.size.height = totalHeight
    }

    public func heightForWidth(
        _ width: CGFloat
    ) -> CGFloat {
        let visibleChildren = visibleChildren()
        let contentWidth = width - layoutMargins.left - layoutMargins.right
        let totalSpacing = max(
            spacing * CGFloat(visibleChildren.count - 1),
            0
        )
        let totalItemWidth = max(
            contentWidth - totalSpacing,
            0
        )
        let infos = layoutInfo(
            for: visibleChildren
        )
        let items = sizeOfItems(
            for: infos,
            in: totalItemWidth
        )
        return height(
            from: items
        )
    }

    // MARK: - helpers

    private func visibleChildren() -> [StackableItemProtocol] {
        return children.filter {
            !$0.isHidden
        }
    }

    private func layoutInfo(
        for children: [StackableItemProtocol]
    ) -> [LayoutInfo] {
        return children.map {
            LayoutInfo(
                item: $0
            )
        }
    }

    private func sizeOfItems(
        for infos: [LayoutInfo],
        in totalWidth: CGFloat
    ) -> [SizeCalculationItem] {
        let items = infos.map {
            SizeCalculationItem(
                info: $0
            )
        }

        guard !items.isEmpty else {
            return items
        }

        adjustItemsWithNoIntrinsicMetric(
            items,
            totalWidth: totalWidth
        )

        var currentTotalWidth = items.reduce(0) {
            $0 + $1.width
        }
        var difference = totalWidth - currentTotalWidth

        while difference != 0 {
            if difference < 0 {
                let sortedByContentCompressionResistancePriority =
                    sortedByContentCompressionResistancePriority(items)
                if let itemToCompress = sortedByContentCompressionResistancePriority.first {
                    let adjustment = min(
                        abs(difference),
                        itemToCompress.width
                    )
                    itemToCompress.width -= adjustment
                    currentTotalWidth -= adjustment
                }
            } else {
                let sortedByContentHuggingPriority = sortedByContentHuggingPriority(items)
                if let itemToExpand = sortedByContentHuggingPriority.first {
                    itemToExpand.width += difference
                    currentTotalWidth += difference
                }
            }

            difference = totalWidth - currentTotalWidth
        }

        return items
    }

    private func adjustItemsWithNoIntrinsicMetric(
        _ items: [SizeCalculationItem],
        totalWidth: CGFloat
    ) {
        let itemsWithNoIntrinsicMetric = Set(
            items.filter {
                $0.info.hasNoInstrincWidth
            }
        )

        guard !itemsWithNoIntrinsicMetric.isEmpty else {
            return
        }

        let totalWidthOfIntrinsicItems =
            items
            .filter {
                $0.info.hasIntrinsicWidth
            }
            .reduce(0) {
                $0 + $1.width
            }
        let totalLeftoverWidth = totalWidth - totalWidthOfIntrinsicItems
        let widthOfNonIntrinsicItem = max(
            0,
            totalLeftoverWidth / CGFloat(itemsWithNoIntrinsicMetric.count)
        )

        items.forEach { item in
            if item.info.hasNoInstrincWidth {
                item.width = widthOfNonIntrinsicItem
            }
        }
    }

    private func height(
        from items: [SizeCalculationItem]
    ) -> CGFloat {
        items.reduce(0) { result, item in
            max(result, item.height)
        } + layoutMargins.vertical
    }

    private func sortedByContentHuggingPriority(
        _ items: [SizeCalculationItem]
    ) -> [SizeCalculationItem] {
        items.stableSorted {
            if $0.info.contentHuggingPriority < $1.info.contentHuggingPriority {
                return true
            } else if $0.info.contentHuggingPriority == $1.info.contentHuggingPriority {
                return $0.width < $1.width
            } else {
                return false
            }
        }
    }

    private func sortedByContentCompressionResistancePriority(
        _ items: [SizeCalculationItem]
    ) -> [SizeCalculationItem] {
        items.stableSorted {
            if $0.info.contentCompressionResistancePriority
                < $1.info.contentCompressionResistancePriority
            {
                return true
            } else if $0.info.contentCompressionResistancePriority
                == $1.info.contentCompressionResistancePriority
            {
                return $0.width > $1.width
            } else {
                return false
            }
        }
    }
}
