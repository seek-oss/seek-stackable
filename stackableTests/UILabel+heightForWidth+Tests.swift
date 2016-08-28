//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import UIKit
@testable import stackable
import XCTest

class UILabel_heightForWidth_Tests: XCTestCase {
    func test_heightForWidth_should_return_expected_result() {
        let font = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        let text = "some text"
        let width: CGFloat = 100
        let label = UILabel()
        label.text = text
        label.font = font
        
        let expectedHeight = label.sizeThatFits(CGSizeMake(width, 9999)).height
        let result = label.heightForWidth(width)
        
        XCTAssertEqual(result, expectedHeight)
    }
}