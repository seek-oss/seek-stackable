//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
import XCTest
@testable import stackable

class UIView_stackSize_Tests: XCTestCase {
    func test_stackSize_with_size_should_return_expected_result() {
        let size = CGSize(width: 100, height: 50)
        
        let view = UIView()
        let result = view.fixed(size: size)
        
        XCTAssertEqual(result.size, size)
        XCTAssertTrue(result.view === view)
    }
    
    func test_stackSize_with_width_and_height_should_return_expected_result() {
        let view = UIView()
        let result = view.fixed(width: 100, height: 50)
        
        XCTAssertEqual(result.size, CGSize(width: 100, height: 50))
        XCTAssertTrue(result.view === view)
    }
}
