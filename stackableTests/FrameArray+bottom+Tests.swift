//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
@testable import stackable
import XCTest

class FrameArray_bottom_Tests: XCTestCase {
    func test_bottom_should_return_bottom_of_lowest_frame() {
        let frames = [
            CGRectMake(0, 10, 0, 50),
            CGRectMake(0, 10, 0, 80),
            CGRectMake(0, 10, 0, 20)
        ]
        
        XCTAssertEqual(frames.bottom, frames[1].origin.y + frames[1].height)
    }
}
