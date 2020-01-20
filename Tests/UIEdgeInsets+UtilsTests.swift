//  Copyright © 2020 SEEK. All rights reserved.
//

import XCTest
@testable import stackable

class UIEdgeInsets_UtilsTests: XCTestCase {
    
    func test_horizontal_insets() {
        let insets = UIEdgeInsets(top: 10, left: 15, bottom: 20, right: 25)
        let horizontalInsets = insets.horizontalInsets
        
        XCTAssertEqual(horizontalInsets, 40)
    }
    
    func test_vertical_insets() {
        let insets = UIEdgeInsets(top: 10, left: 15, bottom: 20, right: 25)
        let verticalInsets = insets.verticalInsets
        
        XCTAssertEqual(verticalInsets, 30)
    }
}
