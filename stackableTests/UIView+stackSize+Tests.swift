//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
@testable import stackable
import XCTest

class UIView_stackSize_Tests: XCTestCase {
    func test_stackSize_should_return_expected_result() {
        let size = CGSizeMake(100, 50)
        
        let view = UIView()
        let result = view.stackSize(size)
        
        XCTAssertEqual(result.size, size)
        XCTAssertTrue(result.view === view)
    }
}