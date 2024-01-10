//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
import XCTest
@testable import stackable

class FrameArray_maxY_Tests: XCTestCase {
    func test_maxY_should_return_maxY_of_lowest_frame() {
        let frames = [
            CGRect(x: 0, y: 10, width: 0, height: 50),
            CGRect(x: 0, y: 10, width: 0, height: 80),
            CGRect(x: 0, y: 10, width: 0, height: 20)
        ]
        
        XCTAssertEqual(frames.maxY, frames[1].maxY)
    }
}
