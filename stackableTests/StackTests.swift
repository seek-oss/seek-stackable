//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import UIKit
import XCTest
@testable import stackable

class StackTests: XCTestCase {
    func test_hidden_for_all_hidden_should_return_true() {
        let label1 = UILabel()
        label1.hidden = true
        let label2 = UILabel()
        label2.hidden = true
        let stack = MockStack(thingsToStack: [ label1, label2 ])
        
        XCTAssertTrue(stack.hidden)
    }
    
    func test_hidden_for_not_all_hidden_should_return_false() {
        let label1 = UILabel()
        label1.hidden = true
        let label2 = UILabel()
        label2.hidden = false
        let stack = MockStack(thingsToStack: [ label1, label2 ])
        
        XCTAssertFalse(stack.hidden)
    }
    
    func test_visibleThingsToStack_should_return_only_non_hidden_stackables() {
        let label1 = UILabel()
        label1.hidden = true
        let label2 = UILabel()
        label2.hidden = false
        let label3 = UILabel()
        label3.hidden = false
        let stack = MockStack(thingsToStack: [ label1, label2, label3 ])
        
        let visibleStackables = stack.visibleThingsToStack()
        XCTAssertEqual(visibleStackables.count, 2)
        XCTAssertTrue(label2 === (visibleStackables[0] as! UILabel))
        XCTAssertTrue(label3 === (visibleStackables[1] as! UILabel))
    }
    
    func test_layoutWithFrames_should_set_frames_as_expected() {
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let frame1 = CGRectMake(0, 0, 20, 10)
        let frame2 = CGRectMake(0, 10, 20, 10)
        let frame3 = CGRectMake(0, 20, 20, 10)
        let stack = MockStack(thingsToStack: [ label1, MockStack(thingsToStack: [ label2 ]), label3 ])
        
        stack.layoutWithFrames([ frame1, frame2, frame3 ])
        
        XCTAssertEqual(label1.frame, frame1)
        XCTAssertEqual(label2.frame, frame2)
        XCTAssertEqual(label3.frame, frame3)
    }
    
    func test_heightForFrames_should_return_expected() {
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let frame1 = CGRectMake(0, 0, 20, 10)
        let frame2 = CGRectMake(0, 10, 20, 10)
        let frame3 = CGRectMake(0, 20, 20, 10)
        let topMargin: CGFloat = 10
        let leftMargin: CGFloat = 8
        let rightMargin: CGFloat = 8
        let bottomMargin: CGFloat = 10
        
        let stack = MockStack(layoutMargins: UIEdgeInsetsMake(topMargin, leftMargin, bottomMargin, rightMargin), thingsToStack: [ label1, MockStack(thingsToStack: [ label2 ]), label3 ])
        
        let frames = [ frame1, frame2, frame3 ]
        let height = stack.heightForFrames(frames)
        XCTAssertEqual(height, frames.bottom + bottomMargin)
    }

    class MockStack: Stack {
        let thingsToStack: [Stackable]
        let spacing: CGFloat
        let layoutMargins: UIEdgeInsets
        
        init(spacing: CGFloat = 0.0, layoutMargins: UIEdgeInsets = UIEdgeInsetsZero, thingsToStack: [Stackable]) {
            self.spacing = spacing
            self.layoutMargins = layoutMargins
            self.thingsToStack = thingsToStack
        }        
 
        func framesForLayout(width: CGFloat, origin: CGPoint) -> [CGRect] {
            fatalError("not implemented")
        }

        func framesForLayout(width: CGFloat) -> [CGRect] {
            fatalError("not implemented")
        }
    }
}