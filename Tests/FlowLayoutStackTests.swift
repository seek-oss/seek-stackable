//  Copyright © 2024 SEEK. All rights reserved.
//

import Foundation
import XCTest
@testable import Stackable

class FlowLayoutStackTests: XCTestCase {
    func test_init_should_set_default_properties() {
        let stack = FlowLayoutStack(
            thingsToStack: []
        )
        
        XCTAssertEqual(
            stack.spacing,
            0.0
        )
        XCTAssertEqual(
            stack.lineSpacing,
            0.0
        )
        XCTAssertEqual(
            stack.layoutMargins,
            .zero
        )
        XCTAssertNil(
            stack.width
        )
        XCTAssertEqual(
            stack.thingsToStack.count,
            0
        )
    }
    
    func test_init_should_properties() {
        let stack = FlowLayoutStack(
            itemSpacing: 5,
            lineSpacing: 10,
            width: 100,
            thingsToStack: [
                UILabel()
            ]
        )
        
        XCTAssertEqual(
            stack.spacing,
            5
        )
        XCTAssertEqual(
            stack.lineSpacing,
            10
        )
        XCTAssertEqual(
            stack.layoutMargins,
            .zero
        )
        XCTAssertEqual(
            stack.width,
            100
        )
        XCTAssertEqual(
            stack.thingsToStack.count,
            1
        )
    }
    
    func test_convenience_init_should_properties() {
        let stack = FlowLayoutStack(
            itemSpacing: 5,
            lineSpacing: 10,
            width: 100
        ) {
            [
                UILabel()
            ]
        }
        
        XCTAssertEqual(
            stack.spacing,
            5
        )
        XCTAssertEqual(
            stack.lineSpacing,
            10
        )
        XCTAssertEqual(
            stack.layoutMargins,
            .zero
        )
        XCTAssertEqual(
            stack.width,
            100
        )
        XCTAssertEqual(
            stack.thingsToStack.count,
            1
        )
    }
    
    func test_framesForLayout_when_thingsToStack_flow_across_multiple_lines_with_different_heights_should_return_expected() {
        let stack = FlowLayoutStack(
            itemSpacing: 5,
            lineSpacing: 10
        ) {
            [
                StackableItemView(
                    frame: .init(
                        origin: .zero,
                        size: CGSize(
                            width: 100,
                            height: 10
                        )
                    )
                ),
                StackableItemView(
                    frame: .init(
                        origin: .zero,
                        size: CGSize(
                            width: 100,
                            height: 50
                        )
                    )
                ),
                StackableItemView(
                    frame: .init(
                        origin: .zero,
                        size: CGSize(
                            width: 200,
                            height: 20
                        )
                    )
                )
            ]
        }

        let frames = stack.framesForLayout(300)

        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 100,
                        height: 10
                    )
                ),
                .init(
                    origin: .init(
                        x: 105,
                        y: 0
                    ),
                    size: .init(
                        width: 100,
                        height: 50
                    )
                ),
                .init(
                    origin: .init(
                        x: 0,
                        y: 60
                    ),
                    size: .init(
                        width: 200,
                        height: 20
                    )
                )
            ]
        )
    }
      
    func test_framesForLayout_when_thingsToStack_contain_fixed_stacks_should_return_expected() {
        let stack = FlowLayoutStack(
            itemSpacing: 5,
            lineSpacing: 10
        ) {
            [
                StackableItemView(
                    frame: .init(
                        origin: .zero,
                        size: CGSize(
                            width: 250,
                            height: 10
                        )
                    )
                ),
                HStack(
                    thingsToStack: [
                        UIView().fixed(
                            size: CGSize(
                                width: 100,
                                height: 10
                            )
                        )
                    ],
                    width: 100
                )
            ]
        }

        let frames = stack.framesForLayout(300)

        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 250,
                        height: 10
                    )
                ),
                .init(
                    origin: .init(
                        x: 0,
                        y: 20
                    ),
                    size: .init(
                        width: 100,
                        height: 10
                    )
                ),
            ]
        )
    }
    
    func test_framesForLayout_when_thingsToStack_contain_stacks_should_return_expected() {
        let stack = FlowLayoutStack(
            itemSpacing: 5,
            lineSpacing: 10
        ) {
            [
                StackableItemView(
                    frame: .init(
                        origin: .zero,
                        size: CGSize(
                            width: 250,
                            height: 10
                        )
                    )
                ),
                HStack(
                    spacing: 8,
                    thingsToStack: [
                        UIView().fixed(
                            size: CGSize(
                                width: 10,
                                height: 10
                            )
                        ),
                        StackableItemView(
                            frame: .init(
                                origin: .zero,
                                size: CGSize(
                                    width: 250,
                                    height: 10
                                )
                            )
                        )
                    ]
                )
            ]
        }

        let frames = stack.framesForLayout(300)

        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 250,
                        height: 10
                    )
                ),
                .init(
                    origin: .init(
                        x: 0,
                        y: 20
                    ),
                    size: .init(
                        width: 10,
                        height: 10
                    )
                ),
                .init(
                    origin: .init(
                        x: 18,
                        y: 20
                    ),
                    size: .init(
                        width: 282,
                        height: 10
                    )
                ),
            ]
        )
    }
    
    func test_framesForLayout_when_thingsToStack_contains_a_single_stackable_that_exceeds_the_width_having_existing_origin_should_return_expected() {
        let stack = FlowLayoutStack(
            itemSpacing: 5,
            lineSpacing: 10
        ) {
            [
                HStack(
                    thingsToStack: [
                        StackableItemView(
                            frame: .init(
                                origin: .zero,
                                size: CGSize(
                                    width: 300,
                                    height: 10
                                )
                            )
                        )
                    ]
                )
            ]
        }

        let frames = stack.framesForLayout(
            100,
            origin: .init(
                x: 0,
                y: 40
            )
        )

        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .init(
                        x: 0,
                        y: 40
                    ),
                    size: .init(
                        width: 100,
                        height: 10
                    )
                ),
            ]
        )
    }

    private class StackableItemView: UIView, StackableItem {
        override var intrinsicContentSize: CGSize {
            frame.size
        }
        
        func heightForWidth(_ width: CGFloat) -> CGFloat {
            frame.height
        }
    }
}
