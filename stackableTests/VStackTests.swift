//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
@testable import stackable
import XCTest

class VStackTests: XCTestCase {
    func test_framesForLayout_should_return_spaced_frames() {
        let spacing: CGFloat = 2
        let view1 = UIView()
        let height1: CGFloat = 10
        let view2 = UIView()
        let height2: CGFloat = 11
        let view3 = UIView()
        let height3: CGFloat = 12
        
        let stack = VStack(spacing: spacing, thingsToStack: [
            view1.stackSize(CGSize(width: 100, height: height1)),
            view2.stackSize(CGSize(width: 100, height: height2)),
            view3.stackSize(CGSize(width: 100, height: height3))
            ])
        
        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, 200) /* TODO: VStack is not currently respecting FixedSizeStackable width */
        XCTAssertEqual(frames[0].size.height, height1)
        // view2
        XCTAssertEqual(frames[1].origin.x, 0)
        XCTAssertEqual(frames[1].origin.y, height1 + spacing)
        XCTAssertEqual(frames[1].size.width, 200)
        XCTAssertEqual(frames[1].size.height, height2)
        // view3
        XCTAssertEqual(frames[2].origin.x, 0)
        XCTAssertEqual(frames[2].origin.y, height1 + spacing + height2 + spacing)
        XCTAssertEqual(frames[2].size.width, 200)
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
        
        let stack = VStack(spacing: spacing, layoutMargins: UIEdgeInsetsMake(topMargin, leftMargin, bottomMargin, rightMargin), thingsToStack: [
            view1.stackSize(CGSize(width: 100, height: height1)),
            view2.stackSize(CGSize(width: 100, height: height2))
            ])
        
        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 2)
        // view1
        XCTAssertEqual(frames[0].origin.x, leftMargin)
        XCTAssertEqual(frames[0].origin.y, topMargin)
        XCTAssertEqual(frames[0].size.width, 200 - leftMargin - rightMargin) /* TODO: VStack is not currently respecting FixedSizeStackable width */
        XCTAssertEqual(frames[0].size.height, height1)
        // view2
        XCTAssertEqual(frames[1].origin.x, leftMargin)
        XCTAssertEqual(frames[1].origin.y, topMargin + height1 + spacing)
        XCTAssertEqual(frames[1].size.width, 200 - leftMargin - rightMargin)
        XCTAssertEqual(frames[1].size.height, height2)
    }

    func test_framesForLayout_should_return_frames_for_nested_vstack() {
        let spacing: CGFloat = 2
        let view1 = UIView()
        let height1: CGFloat = 10
        let spacing2: CGFloat = 1
        let view2 = UIView()
        let height2: CGFloat = 11
        let view3 = UIView()
        let height3: CGFloat = 12
        
        let stack = VStack(spacing: spacing, thingsToStack: [
            view1.stackSize(CGSize(width: 100, height: height1)),
            VStack(spacing: spacing2, thingsToStack: [
                view2.stackSize(CGSize(width: 100, height: height2)),
                view3.stackSize(CGSize(width: 100, height: height3))
                ])
            ])
        
        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, 200) /* TODO: VStack is not currently respecting FixedSizeStackable width */
        XCTAssertEqual(frames[0].size.height, height1)
        // view2
        XCTAssertEqual(frames[1].origin.x, 0)
        XCTAssertEqual(frames[1].origin.y, height1 + spacing)
        XCTAssertEqual(frames[1].size.width, 200)
        XCTAssertEqual(frames[1].size.height, height2)
        // view3
        XCTAssertEqual(frames[2].origin.x, 0)
        XCTAssertEqual(frames[2].origin.y, height1 + spacing + height2 + spacing2)
        XCTAssertEqual(frames[2].size.width, 200)
        XCTAssertEqual(frames[2].size.height, height3)
    }

    func test_framesForLayout_should_return_frames_for_nested_hstack() {
        let spacing: CGFloat = 2
        let view1 = UIView()
        let height1: CGFloat = 10
        let spacing2: CGFloat = 10
        let view2 = UIView()
        let size2 = CGSize(width: 50, height: 11)
        let view3 = UIView()
        let size3 = CGSize(width: 60, height: 12)
        
        let stack = VStack(spacing: spacing, thingsToStack: [
            view1.stackSize(CGSize(width: 100, height: height1)),
            HStack(spacing: spacing2, thingsToStack: [
                view2.stackSize(size2),
                view3.stackSize(size3)
                ])
            ])
        
        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, 200) /* TODO: VStack is not currently respecting FixedSizeStackable width */
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
}
