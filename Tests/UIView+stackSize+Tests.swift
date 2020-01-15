//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
@testable import stackable
import XCTest

class UIView_stackSize_Tests: XCTestCase {
    func test_stackSize_should_return_expected_result() {
        let size = CGSize(width: 100, height: 50)
        
        let view = UIView()
        let result = view.fixed(size: size)
        
        XCTAssertEqual(result.size, size)
        XCTAssertTrue(result.view === view)
    }
}
