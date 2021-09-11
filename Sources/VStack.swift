//  Copyright © 2021 SEEK Limited. All rights reserved.
//

import UIKit

open class VStack: UIView, StackableItemProtocol {
    public enum Alignment {
        case leading
        case center
        case trailing
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

        let intrinsicSizes = children.map { $0.intrinsicContentSize }

        let childHasNoIntrinsicWidth = intrinsicSizes.contains(
            where: { $0.width.isNoIntrinsicMetric }
        )
        let childHasNoIntrinsicHeight = intrinsicSizes.contains(
            where: { $0.height.isNoIntrinsicMetric }
        )

        let intrinsicWidth: CGFloat
        if childHasNoIntrinsicWidth {
            intrinsicWidth = UIView.noIntrinsicMetric
        } else {
            intrinsicWidth = intrinsicSizes.reduce(0) {
                max($0, $1.width)
            }
        }

        let intrinsicHeight: CGFloat
        if childHasNoIntrinsicHeight {
            intrinsicHeight = UIView.noIntrinsicMetric
        } else {
            let totalHeightOfItems = intrinsicSizes.reduce(0) {
                $0 + $1.height
            }
            let totalVerticalSpacing = max(CGFloat(children.count) - 1, 0) * spacing
            intrinsicHeight = totalHeightOfItems + totalVerticalSpacing
        }

        return CGSize(
            width: intrinsicWidth + layoutMargins.horizontal,
            height: intrinsicHeight + layoutMargins.vertical
        )
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let visibleChildren = visibleChildren()

        guard bounds != .zero
        else {
            visibleChildren.forEach {
                $0.frame = .zero
            }
            return
        }

        let x = bounds.origin.x + layoutMargins.left
        var y = bounds.origin.y + layoutMargins.top
        let width = bounds.width - layoutMargins.left - layoutMargins.right

        visibleChildren.forEach { child in
            let height = child.heightForWidth(width)
            let intrinsicWidth = child.intrinsicContentSize.width

            let idealWidth: CGFloat
            if intrinsicWidth == UIView.noIntrinsicMetric {
                idealWidth = width
            } else {
                idealWidth = min(
                    width,
                    intrinsicWidth
                )
            }

            let frame = CGRect(
                x: x,
                y: y,
                width: width,
                height: height
            )

            switch alignment {
            case .leading:
                child.frame = frame.bySetting(
                    width: idealWidth,
                    anchoredTo: .leading
                )
            case .center:
                child.frame = frame.bySetting(
                    width: idealWidth,
                    anchoredTo: .center
                )
            case .trailing:
                child.frame = frame.bySetting(
                    width: idealWidth,
                    anchoredTo: .trailing
                )
            case .fill:
                child.frame = frame
            }

            y += height + spacing
        }
    }

    public func heightForWidth(_ width: CGFloat) -> CGFloat {
        let children = visibleChildren()

        let totalVerticalSpacing = max(CGFloat(children.count) - 1, 0) * spacing
        let totalHeightOfItems = children.reduce(0) {
            $0 + $1.heightForWidth(width)
        }

        return totalHeightOfItems + totalVerticalSpacing + layoutMargins.vertical
    }

    // MARK: - helpers

    private func visibleChildren() -> [StackableItemProtocol] {
        return children.filter {
            !$0.isHidden
        }
    }
}
