//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
@testable import stackable
import XCTest

class HStackTests: XCTestCase {
    func test_framesForLayout_should_return_spaced_frames() {
        let spacing: CGFloat = 2
        let view1 = UIView()
        let size1 = CGSize(width: 50, height: 10)
        let view2 = UIView()
        let size2 = CGSize(width: 55, height: 11)
        let view3 = UIView()
        let size3 = CGSize(width: 60, height: 12)
        
        let stack = HStack(spacing: spacing, thingsToStack: [
            view1.stackSize(size1),
            view2.stackSize(size2),
            view3.stackSize(size3)
            ])
        
        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, size1.width)
        XCTAssertEqual(frames[0].size.height, size1.height)
        // view2
        XCTAssertEqual(frames[1].origin.x, size1.width + spacing)
        XCTAssertEqual(frames[1].origin.y, 0)
        XCTAssertEqual(frames[1].size.width, size2.width)
        XCTAssertEqual(frames[1].size.height, size2.height)
        // view3
        XCTAssertEqual(frames[2].origin.x, size1.width + spacing + size2.width + spacing)
        XCTAssertEqual(frames[2].origin.y, 0)
        XCTAssertEqual(frames[2].size.width, size3.width)
        XCTAssertEqual(frames[2].size.height, size3.height)
    }

    func test_framesForLayout_should_return_frames_with_margins() {
        let topMargin: CGFloat = 10
        let leftMargin: CGFloat = 8
        let bottomMargin: CGFloat = 10
        let rightMargin: CGFloat = 8

        let spacing: CGFloat = 2
        let view1 = UIView()
        let size1 = CGSize(width: 50, height: 10)
        let view2 = UIView()
        let size2 = CGSize(width: 55, height: 11)
        
        let stack = HStack(spacing: spacing, layoutMargins: UIEdgeInsets(top: topMargin, left: leftMargin, bottom: bottomMargin, right: rightMargin), thingsToStack: [
            view1.stackSize(size1),
            view2.stackSize(size2)
            ])
        
        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 2)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0) // TODO: HStack is currently not respecting margins
        XCTAssertEqual(frames[0].size.width, size1.width)
        XCTAssertEqual(frames[0].size.height, size1.height)
        // view2
        XCTAssertEqual(frames[1].origin.x, size1.width + spacing)
        XCTAssertEqual(frames[1].origin.y, 0)
        XCTAssertEqual(frames[1].size.width, size2.width)
        XCTAssertEqual(frames[1].size.height, size2.height)
    }

    func test_framesForLayout_should_return_frames_for_nested_vstack() {
        let spacing: CGFloat = 2
        let spacing2: CGFloat = 1
        let view1 = UIView()
        let size1 = CGSize(width: 50, height: 10)
        let view2 = UIView()
        let size2 = CGSize(width: 55, height: 11)
        let view3 = UIView()
        let size3 = CGSize(width: 60, height: 12)
        
        let stack = HStack(spacing: spacing, thingsToStack: [
            VStack(spacing: spacing2, thingsToStack: [
                view1.stackSize(size1),
                view2.stackSize(size2)
                ]),
            view3.stackSize(size3)
            ])
        
        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, 200 - size3.width - spacing)
        XCTAssertEqual(frames[0].size.height, size1.height)
        // view2
        XCTAssertEqual(frames[1].origin.x, 0)
        XCTAssertEqual(frames[1].origin.y, size1.height + spacing2)
        XCTAssertEqual(frames[1].size.width, 200 - size3.width - spacing)
        XCTAssertEqual(frames[1].size.height, size2.height)
        // view3
        XCTAssertEqual(frames[2].origin.x, 200 - size3.width)
        XCTAssertEqual(frames[2].origin.y, 0)
        XCTAssertEqual(frames[2].size.width, size3.width)
        XCTAssertEqual(frames[2].size.height, size3.height)
    }
    
    func test_framesForLayout_should_return_frames_for_nested_vstack_with_fixed_width() {
        let spacing: CGFloat = 2
        let spacing2: CGFloat = 1
        let view1 = UIView()
        let size1 = CGSize(width: 100, height: 10)
        let view2 = UIView()
        let size2 = CGSize(width: 100, height: 11)
        let view3 = UIView()
        let size3 = CGSize(width: 60, height: 12)
        let fixedVStackWidth: CGFloat = 50
        
        let stack = HStack(spacing: spacing, thingsToStack: [
            VStack(spacing: spacing2, thingsToStack: [
                view1.stackSize(size1),
                view2.stackSize(size2)
            ], width: fixedVStackWidth),
            view3.stackSize(size3)
        ])
        
        let frames = stack.framesForLayout(200)
        XCTAssertEqual(frames.count, 3)
        // view1
        XCTAssertEqual(frames[0].origin.x, 0)
        XCTAssertEqual(frames[0].origin.y, 0)
        XCTAssertEqual(frames[0].size.width, fixedVStackWidth)
        XCTAssertEqual(frames[0].size.height, size1.height)
        // view2
        XCTAssertEqual(frames[1].origin.x, 0)
        XCTAssertEqual(frames[1].origin.y, size1.height + spacing2)
        XCTAssertEqual(frames[1].size.width, fixedVStackWidth)
        XCTAssertEqual(frames[1].size.height, size2.height)
        // view3
        XCTAssertEqual(frames[2].origin.x, fixedVStackWidth + spacing)
        XCTAssertEqual(frames[2].origin.y, 0)
        XCTAssertEqual(frames[2].size.width, size3.width)
        XCTAssertEqual(frames[2].size.height, size3.height)
    }
}
