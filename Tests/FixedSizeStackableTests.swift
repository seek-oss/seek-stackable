//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import Foundation
import XCTest
@testable import stackable

class FixedSizeStackableTests: XCTestCase {
    func test_view_should_return_expected() {
        let view = UIView()
        let stackable = FixedSizeStackable(view: view, size: CGSize(width: 100, height: 50))
        
        XCTAssertTrue(stackable.view === view)
    }

    func test_size_should_return_expected() {
        let width: CGFloat = 100
        let height: CGFloat = 50
        let stackable = FixedSizeStackable(view: UIView(), size: CGSize(width: width, height: height))
        
        XCTAssertEqual(stackable.size.width, width)
        XCTAssertEqual(stackable.size.height, height)
    }
    
    func test_convenience_init_should_initialize_correctly() {
        let view = UIView()
        let stackable = FixedSizeStackable(view: view, width: 100, height: 50)
        
        XCTAssertTrue(stackable.view === view)
        XCTAssertEqual(stackable.size, CGSize(width: 100, height: 50))
    }
    
    func test_heightForWidth_should_return_expected() {
        let width: CGFloat = 100
        let height: CGFloat = 50
        let stackable = FixedSizeStackable(view: UIView(), size: CGSize(width: width, height: height))
        
        let result = stackable.heightForWidth(width)
        
        XCTAssertEqual(result, height)
    }
    
    func test_hidden_should_return_expected() {
        let view = UIView()
        let stackable = FixedSizeStackable(view: view, size: CGSize(width: 100, height: 50))
        
        view.isHidden = false
        XCTAssertFalse(stackable.isHidden)
        view.isHidden = true
        XCTAssertTrue(stackable.isHidden)
    }
    
    func test_intrinsicContentSize_should_return_expected() {
        let stackable = FixedSizeStackable(view: UIView(), size: CGSize(width: 100, height: 50))
        
        XCTAssertEqual(stackable.intrinsicContentSize, CGSize(width: 100, height: 50))
    }
}

