//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
@testable import stackable
import XCTest

class FixedSizeStackableTests: XCTestCase {
    func test_view_should_return_expected() {
        let view = UIView()
        let stackable = FixedSizeStackable(view: view, size: CGSizeMake(100, 50))
        
        XCTAssertTrue(stackable.view === view)
    }

    func test_size_should_return_expected() {
        let width: CGFloat = 100
        let height: CGFloat = 50
        let stackable = FixedSizeStackable(view: UIView(), size: CGSizeMake(width, height))
        
        XCTAssertEqual(stackable.size.width, width)
        XCTAssertEqual(stackable.size.height, height)
    }
    
    func test_heightForWidth_should_return_expected() {
        let width: CGFloat = 100
        let height: CGFloat = 50
        let stackable = FixedSizeStackable(view: UIView(), size: CGSizeMake(width, height))
        
        let result = stackable.heightForWidth(width)
        
        XCTAssertEqual(result, height)
    }
    
    func test_hidden_should_return_expected() {
        let view = UIView()
        let stackable = FixedSizeStackable(view: view, size: CGSizeMake(100, 50))
        
        view.hidden = false
        XCTAssertFalse(stackable.hidden)
        view.hidden = true
        XCTAssertTrue(stackable.hidden)
    }
}
