//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
@testable import stackable
import XCTest

class CGRectProtocol_bottom_Tests: XCTestCase {
    func test_bottom_should_return_expected() {
        let x: CGFloat = 10
        let y: CGFloat = 20
        let width: CGFloat = 100
        let height: CGFloat = 50
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        XCTAssertEqual(rect.bottom, y + height)
    }
}
