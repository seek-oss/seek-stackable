//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
@testable import stackable
import XCTest

class FrameArray_bottom_Tests: XCTestCase {
    func test_bottom_should_return_bottom_of_lowest_frame() {
        let frames = [
            CGRect(x: 0, y: 10, width: 0, height: 50),
            CGRect(x: 0, y: 10, width: 0, height: 80),
            CGRect(x: 0, y: 10, width: 0, height: 20)
        ]
        
        XCTAssertEqual(frames.bottom, frames[1].origin.y + frames[1].height)
    }
}
