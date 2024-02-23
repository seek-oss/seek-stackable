//  Copyright © 2016 SEEK Limited. All rights reserved.
//

import XCTest

@testable import Stackable

final class HStackTests: XCTestCase {
    func test_init_should_set_default_properties() {
        let stack = HStack(
            thingsToStack: []
        )
        
        XCTAssertEqual(
            stack.spacing,
            0.0
        )
        XCTAssertEqual(
            stack.distribution,
            .fillEqually
        )
        XCTAssertEqual(
            stack.layoutMargins,
            .zero
        )
        XCTAssertEqual(
            stack.thingsToStack.count,
            0
        )
        XCTAssertNil(
            stack.width
        )
    }
    
    func test_init_should_set_properties() {
        let stack = HStack(
            spacing: 8,
            distribution: .fill,
            layoutMargins: .init(
                top: 10,
                left: 10,
                bottom: 10,
                right: 10
            ),
            thingsToStack: [
                UILabel()
            ],
            width: 100
        )
        
        XCTAssertEqual(
            stack.spacing,
            8
        )
        XCTAssertEqual(
            stack.distribution,
            .fill
        )
        XCTAssertEqual(
            stack.layoutMargins,
            .init(
                top: 10,
                left: 10,
                bottom: 10,
                right: 10
            )
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
    
    func test_convenience_init_should_set_properties() {
        let stack = HStack(
            spacing: 8,
            distribution: .fill,
            layoutMargins: .init(
                top: 10,
                left: 10,
                bottom: 10,
                right: 10
            ),
            width: 100
        ) {
            [
                UILabel()
            ]
        }
        
        XCTAssertEqual(
            stack.spacing,
            8
        )
        XCTAssertEqual(
            stack.distribution,
            .fill
        )
        XCTAssertEqual(
            stack.layoutMargins,
            .init(
                top: 10,
                left: 10,
                bottom: 10,
                right: 10
            )
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
    
    func test_framesForLayout_should_return_expected_frames() {
        let stack = HStack(
            spacing: 2,
            thingsToStack: [
                UIView().fixed(
                    size: CGSize(
                        width: 50,
                        height: 10
                    )
                ),
                UIView().fixed(
                    size: CGSize(
                        width: 55,
                        height: 11
                    )
                ),
                UIView().fixed(
                    size: CGSize(
                        width: 60,
                        height: 12
                    )
                )
            ]
        )
        
        let frames = stack.framesForLayout(200)
        
        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 50,
                        height: 10
                    )
                ),
                .init(
                    origin: .init(
                        x: 52,
                        y: 0
                    ),
                    size: .init(
                        width: 55,
                        height: 11
                    )
                ),
                .init(
                    origin: .init(
                        x: 109,
                        y: 0
                    ),
                    size: .init(
                        width: 60,
                        height: 12
                    )
                )
                
            ]
        )
    }

    func test_framesForLayout_should_return_frames_with_margins() {
        let stack = HStack(
            spacing: 2,
            layoutMargins: .init(
                top: 10,
                left: 8,
                bottom: 10,
                right: 8
            ),
            thingsToStack: [
                UIView().fixed(
                    size: CGSize(
                        width: 50,
                        height: 10
                    )
                ),
                UIView().fixed(
                    size: CGSize(
                        width: 55,
                        height: 11
                    )
                )
            ]
        )
        
        let frames = stack.framesForLayout(200)
        
        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 50,
                        height: 10
                    )
                ),
                .init(
                    origin: .init(
                        x: 52,
                        y: 0 // TODO: HStack is currently not respecting margins
                    ),
                    size: .init(
                        width: 55,
                        height: 11
                    )
                )
            ]
        )
    }

    func test_framesForLayout_should_return_frames_for_nested_vstack() {
        let stack = HStack(
            spacing: 2,
            thingsToStack: [
                VStack(
                    spacing: 1,
                    thingsToStack: [
                        UIView().fixed(
                            size: .init(
                                width: 50,
                                height: 10
                            )
                        ),
                        UIView().fixed(
                            size: .init(
                                width: 55,
                                height: 11
                            )
                        )
                    ]
                ),
                UIView().fixed(
                    size: .init(
                        width: 60,
                        height: 12
                    )
                )
            ]
        )
        
        let frames = stack.framesForLayout(200)

        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 50,
                        height: 10
                    )
                ),
                .init(
                    origin: .init(
                        x: 0,
                        y: 11
                    ),
                    size: .init(
                        width: 55,
                        height: 11
                    )
                ),
                .init(
                    origin: .init(
                        x: 140,
                        y: 0
                    ),
                    size: .init(
                        width: 60,
                        height: 12
                    )
                )
            ]
        )
    }
    
    func test_framesForLayout_should_return_frames_for_nested_vstack_with_fixed_width() {
        let stack = HStack(
            spacing: 2,
            thingsToStack: [
                VStack(
                    spacing: 1,
                    thingsToStack: [
                        UIView().fixed(
                            size: .init(
                                width: 100,
                                height: 10
                            )
                        ),
                        UIView().fixed(
                            size: .init(
                                width: 100,
                                height: 11
                            )
                        )
                    ],
                    width: 50
                ),
                UIView().fixed(
                    size: .init(
                        width: 60,
                        height: 12
                    )
                )
            ]
        )
        
        let frames = stack.framesForLayout(200)
        
        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 50,
                        height: 10
                    )
                ),
                .init(
                    origin: .init(
                        x: 0,
                        y: 11
                    ),
                    size: .init(
                        width: 50,
                        height: 11
                    )
                ),
                .init(
                    origin: .init(
                        x: 52,
                        y: 0
                    ),
                    size: .init(
                        width: 60,
                        height: 12
                    )
                )
            ]
        )
    }
    
    func test_framesForLayout_when_distribution_is_fill_should_return_expected_frames() {
        let label1 = UILabel()
        label1.text = "Some text"
        let label2 = UILabel()
        label2.text = "Some longer text"
        let label3 = UILabel()
        label3.text = "Some longer longer text"
        
        let stack = HStack(
            spacing: 4,
            distribution: .fill,
            thingsToStack: [
                label1,
                UIView().fixed(
                    size: .init(
                        width: 100,
                        height: 14
                    )
                ),
                label2,
                label3
            ]
        )
        
        let frames = stack.framesForLayout(200)
        
        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 77,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 81,
                        y: 0
                    ),
                    size: .init(
                        width: 100,
                        height: 14
                    )
                ),
                .init(
                    origin: .init(
                        x: 185,
                        y: 0
                    ),
                    size: .init(
                        width: 15,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 204,
                        y: 0
                    ),
                    size: .init(
                        width: 0,
                        height: 20.5
                    )
                )
            ]
        )
    }
    
    func test_framesForLayout_when_distribution_is_fill_and_having_children_with_distribution_fill_should_return_expected_frames() {
        let label1 = UILabel()
        label1.text = "Text"
        let label2 = UILabel()
        label2.text = "Some text"
        let label3 = UILabel()
        label3.text = "Some longer text"
        
        let stack = HStack(
            spacing: 4,
            distribution: .fill,
            thingsToStack: [
                label1,
                HStack(
                    spacing: 8,
                    distribution: .fill,
                    thingsToStack: [
                        label2,
                        UIView().fixed(
                            size: .init(
                                width: 15,
                                height: 16
                            )
                        ),
                        label3,
                        UIView().fixed(
                            size: .init(
                                width: 100,
                                height: 14
                            )
                        )
                    ]
                )
            ]
        )
        
        let frames = stack.framesForLayout(200)
        
        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 32,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 36,
                        y: 0
                    ),
                    size: .init(
                        width: 77,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 121,
                        y: 0
                    ),
                    size: .init(
                        width: 15,
                        height: 16
                    )
                ),
                .init(
                    origin: .init(
                        x: 144,
                        y: 0
                    ),
                    size: .init(
                        width: 56,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 208,
                        y: 0
                    ),
                    size: .init(
                        width: 0,
                        height: 14
                    )
                )
            ]
        )
    }
    
    func test_framesForLayout_when_distribution_is_fillEqually_and_having_children_with_distribution_fill_should_return_expected_frames() {
        let label1 = UILabel()
        label1.text = "Text"
        let label2 = UILabel()
        label2.text = "Some text"
        let label3 = UILabel()
        label3.text = "Some longer text"
        
        let stack = HStack(
            spacing: 4,
            thingsToStack: [
                label1,
                HStack(
                    spacing: 8,
                    distribution: .fill,
                    thingsToStack: [
                        label2,
                        UIView().fixed(
                            size: .init(
                                width: 15,
                                height: 16
                            )
                        ),
                        label3,
                        UIView().fixed(
                            size: .init(
                                width: 100,
                                height: 14
                            )
                        )
                    ]
                )
            ]
        )
        
        let frames = stack.framesForLayout(200)

        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 98,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 102,
                        y: 0
                    ),
                    size: .init(
                        width: 77,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 187,
                        y: 0
                    ),
                    size: .init(
                        width: 13,
                        height: 16
                    )
                ),
                .init(
                    origin: .init(
                        x: 208,
                        y: 0
                    ),
                    size: .init(
                        width: 0,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 216,
                        y: 0
                    ),
                    size: .init(
                        width: 0,
                        height: 14
                    )
                )
            ]
        )
    }
    
    func test_framesForLayout_when_distribution_is_fill_and_having_children_with_distribution_fillEqually_should_return_expected_frames() {
        let label1 = UILabel()
        label1.text = "Text"
        let label2 = UILabel()
        label2.text = "Some text"
        let label3 = UILabel()
        label3.text = "Some longer text"
        
        let stack = HStack(
            spacing: 4,
            distribution: .fill,
            thingsToStack: [
                label1,
                HStack(
                    spacing: 8,
                    thingsToStack: [
                        label2,
                        label3,
                        UIView().fixed(
                            size: .init(
                                width: 30,
                                height: 14
                            )
                        )
                    ]
                )
            ]
        )
        
        let frames = stack.framesForLayout(200)
        
        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 32,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 36,
                        y: 0
                    ),
                    size: .init(
                        width: 59,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 103,
                        y: 0
                    ),
                    size: .init(
                        width: 59,
                        height: 20.5
                    )
                ),
                .init(
                    origin: .init(
                        x: 170,
                        y: 0
                    ),
                    size: .init(
                        width: 30,
                        height: 14
                    )
                )
            ]
        )
    }
    
    func test_framesForLayout_when_distribution_is_fill_should_return_frames_for_nested_vstack_with_fixed_width() {
        let stack = HStack(
            spacing: 2,
            distribution: .fill,
            thingsToStack: [
                VStack(
                    spacing: 1,
                    thingsToStack: [
                        UIView().fixed(
                            size: .init(
                                width: 100,
                                height: 10
                            )
                        ),
                        UIView().fixed(
                            size: .init(
                                width: 100,
                                height: 11
                            )
                        )
                    ],
                    width: 50
                ),
                UIView().fixed(
                    size: .init(
                        width: 60,
                        height: 12
                    )
                )
            ]
        )
        
        let frames = stack.framesForLayout(200)
        
        XCTAssertEqual(
            frames,
            [
                .init(
                    origin: .zero,
                    size: .init(
                        width: 50,
                        height: 10
                    )
                ),
                .init(
                    origin: .init(
                        x: 0,
                        y: 11
                    ),
                    size: .init(
                        width: 50,
                        height: 11
                    )
                ),
                .init(
                    origin: .init(
                        x: 52,
                        y: 0
                    ),
                    size: .init(
                        width: 60,
                        height: 12
                    )
                )
            ]
        )
    }
    
    func test_intrinsicContentSize_should_return_correct_size() {
        let stack = HStack(spacing: 5, thingsToStack: [
            UIView().fixed(width: 100, height: 100),
            UIView().fixed(width: 200, height: 50)
        ])
        
        XCTAssertEqual(stack.intrinsicContentSize, CGSize(width: 305, height: 100))
    }
    
    func test_intrinsicContentSize_should_return_zero_when_items_are_hidden() {
        let view1 = UIView()
        view1.isHidden = true
        let view2 = UIView()
        view2.isHidden = true
        
        let stack = HStack(spacing: 5, thingsToStack: [
            view1.fixed(width: 100, height: 100),
            view2.fixed(width: 200, height: 50)
        ])
        
        XCTAssertEqual(stack.intrinsicContentSize, .zero)
    }
}
