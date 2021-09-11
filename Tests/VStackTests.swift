//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
import XCTest

@testable import Stackable

class OldVStackTests: XCTestCase {
    func test_framesForLayout_should_return_spaced_frames() {
        let spacing: CGFloat = 2
        let view1 = UIView()
        let height1: CGFloat = 10
        let view2 = UIView()
        let height2: CGFloat = 11
        let view3 = UIView()
        let height3: CGFloat = 12

        let stack = OldVStack(
            spacing: spacing,
            thingsToStack: [
                view1.fixed(width: 100, height: height1),
                view2.fixed(width: 100, height: height2),
                view3.fixed(width: 100, height: height3),
            ]
        )

        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, 100)
        XCTAssertEqual(frames[0].size.height, height1)
        // view2
        XCTAssertEqual(frames[1].origin.x, 0)
        XCTAssertEqual(frames[1].origin.y, height1 + spacing)
        XCTAssertEqual(frames[1].size.width, 100)
        XCTAssertEqual(frames[1].size.height, height2)
        // view3
        XCTAssertEqual(frames[2].origin.x, 0)
        XCTAssertEqual(frames[2].origin.y, height1 + spacing + height2 + spacing)
        XCTAssertEqual(frames[2].size.width, 100)
        XCTAssertEqual(frames[2].size.height, height3)
    }

    func test_framesForLayout_should_return_frames_with_margins() {
        let topMargin: CGFloat = 10
        let leftMargin: CGFloat = 8
        let bottomMargin: CGFloat = 10
        let rightMargin: CGFloat = 8

        let spacing: CGFloat = 2
        let view1 = UIView()
        let height1: CGFloat = 10
        let view2 = UIView()
        let height2: CGFloat = 11

        let stack = OldVStack(
            spacing: spacing,
            layoutMargins: UIEdgeInsets(top: topMargin, left: leftMargin, bottom: bottomMargin, right: rightMargin),
            thingsToStack: [
                view1.fixed(width: 100, height: height1),
                view2.fixed(width: 100, height: height2),
            ]
        )

        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 2)
        // view1
        XCTAssertEqual(frames[0].origin.x, leftMargin)
        XCTAssertEqual(frames[0].origin.y, topMargin)
        XCTAssertEqual(frames[0].size.width, 100)
        XCTAssertEqual(frames[0].size.height, height1)
        // view2
        XCTAssertEqual(frames[1].origin.x, leftMargin)
        XCTAssertEqual(frames[1].origin.y, topMargin + height1 + spacing)
        XCTAssertEqual(frames[1].size.width, 100)
        XCTAssertEqual(frames[1].size.height, height2)
    }

    func test_framesForLayout_should_return_frames_for_nested_OldVStack() {
        let spacing: CGFloat = 2
        let view1 = UIView()
        let height1: CGFloat = 10
        let spacing2: CGFloat = 1
        let view2 = UIView()
        let height2: CGFloat = 11
        let view3 = UIView()
        let height3: CGFloat = 12

        let stack = OldVStack(
            spacing: spacing,
            thingsToStack: [
                view1.fixed(width: 100, height: height1),
                OldVStack(
                    spacing: spacing2,
                    thingsToStack: [
                        view2.fixed(width: 100, height: height2),
                        view3.fixed(width: 100, height: height3),
                    ]
                ),
            ]
        )

        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, 100)
        XCTAssertEqual(frames[0].size.height, height1)
        // view2
        XCTAssertEqual(frames[1].origin.x, 0)
        XCTAssertEqual(frames[1].origin.y, height1 + spacing)
        XCTAssertEqual(frames[1].size.width, 100)
        XCTAssertEqual(frames[1].size.height, height2)
        // view3
        XCTAssertEqual(frames[2].origin.x, 0)
        XCTAssertEqual(frames[2].origin.y, height1 + spacing + height2 + spacing2)
        XCTAssertEqual(frames[2].size.width, 100)
        XCTAssertEqual(frames[2].size.height, height3)
    }

    func test_framesForLayout_should_return_frames_for_nested_OldHStack() {
        let spacing: CGFloat = 2
        let view1 = UIView()
        let height1: CGFloat = 10
        let spacing2: CGFloat = 10
        let view2 = UIView()
        let size2 = CGSize(width: 50, height: 11)
        let view3 = UIView()
        let size3 = CGSize(width: 60, height: 12)

        let stack = OldVStack(
            spacing: spacing,
            thingsToStack: [
                view1.fixed(width: 100, height: height1),
                OldHStack(
                    spacing: spacing2,
                    thingsToStack: [
                        view2.fixed(size: size2),
                        view3.fixed(size: size3),
                    ]
                ),
            ]
        )

        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, 100)
        XCTAssertEqual(frames[0].size.height, height1)
        // view2
        XCTAssertEqual(frames[1].origin.x, 0)
        XCTAssertEqual(frames[1].origin.y, height1 + spacing)
        XCTAssertEqual(frames[1].size.width, size2.width)
        XCTAssertEqual(frames[1].size.height, size2.height)
        // view3
        XCTAssertEqual(frames[2].origin.x, 50 + spacing2)
        XCTAssertEqual(frames[2].origin.y, height1 + spacing)
        XCTAssertEqual(frames[2].size.width, size3.width)
        XCTAssertEqual(frames[2].size.height, size3.height)
    }

    func test_framesForLayout_with_layoutMargins_should_return_frames_for_nested_OldHStack() {
        let spacing: CGFloat = 2
        let view1 = UIView()
        let height1: CGFloat = 10
        let spacing2: CGFloat = 10
        let view2 = UIView()
        let size2 = CGSize(width: 50, height: 11)
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, ut sed agam omittantur, te brute delicata vel, vel detraxit concludaturque ne."
        let topMargin: CGFloat = 10
        let leftMargin: CGFloat = 8
        let bottomMargin: CGFloat = 10
        let rightMargin: CGFloat = 8

        let stack = OldVStack(
            spacing: spacing,
            thingsToStack: [
                view1.fixed(width: 100, height: height1),
                OldHStack(
                    spacing: spacing2,
                    layoutMargins: UIEdgeInsets(
                        top: topMargin,
                        left: leftMargin,
                        bottom: bottomMargin,
                        right: rightMargin
                    ),
                    thingsToStack: [
                        view2.fixed(size: size2),
                        label,
                    ]
                ),
            ]
        )

        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, 100)
        XCTAssertEqual(frames[0].size.height, height1)
        // view2
        XCTAssertEqual(frames[1].origin.x, leftMargin)
        XCTAssertEqual(frames[1].origin.y, height1 + spacing + topMargin)
        XCTAssertEqual(frames[1].size.width, size2.width)
        XCTAssertEqual(frames[1].size.height, size2.height)
        // view3
        XCTAssertEqual(frames[2].origin.x, 50 + spacing2 + leftMargin)
        XCTAssertEqual(frames[2].origin.y, height1 + spacing + topMargin)
        XCTAssertEqual(frames[2].size.width, 200 - frames[1].maxX - spacing2 - rightMargin)
        XCTAssertEqual(frames[2].size.height, label.heightForWidth(200 - frames[1].maxX - spacing2 - rightMargin))
    }

    func test_convenience_init_with_thingsToStack_closure() {
        let layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let spacing: CGFloat = 2
        let view1 = UILabel()
        let view2 = UILabel()

        let stack = OldVStack(
            spacing: spacing,
            layoutMargins: layoutMargins,
            width: 200
        ) {
            [
                view1,
                view2,
            ]
        }

        XCTAssertEqual(stack.spacing, 2)
        XCTAssertEqual(stack.layoutMargins, layoutMargins)
        XCTAssertEqual(stack.width, 200)
        XCTAssertEqual(stack.thingsToStack.count, 2)
        XCTAssertEqual(
            stack.thingsToStack as? [UILabel],
            [
                view1,
                view2,
            ]
        )
    }

    func test_intrinsicContentSize_should_return_correct_size() {
        let stack = OldVStack(
            spacing: 5,
            layoutMargins: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10),
            thingsToStack: [
                UIView().fixed(width: 100, height: 100),
                UIView().fixed(width: 200, height: 50),
            ]
        )

        XCTAssertEqual(stack.intrinsicContentSize, CGSize(width: 220, height: 195))
    }

    func test_intrinsicContentSize_should_return_zero_when_items_are_hidden() {
        let view1 = UIView()
        view1.isHidden = true
        let view2 = UIView()
        view2.isHidden = true

        let stack = OldVStack(
            spacing: 5,
            layoutMargins: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10),
            thingsToStack: [
                view1.fixed(width: 100, height: 100),
                view2.fixed(width: 200, height: 50),
            ]
        )

        XCTAssertEqual(stack.intrinsicContentSize, .zero)
    }
}
