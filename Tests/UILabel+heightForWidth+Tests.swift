//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import UIKit
import XCTest

@testable import stackable

class UILabel_heightForWidth_Tests: XCTestCase {
    func test_heightForWidth_should_return_expected_result() {
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let text = "some text"
        let width: CGFloat = 100
        let label = UILabel()
        label.text = text
        label.font = font

        let expectedHeight = label.sizeThatFits(CGSize(width: width, height: 9999)).height
        let result = label.heightForWidth(width)

        XCTAssertEqual(result, expectedHeight)
    }
}
