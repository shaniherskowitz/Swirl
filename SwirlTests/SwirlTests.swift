//
//  SwirlTests.swift
//  SwirlTests
//
//  Created by shani herskowitz on 4/12/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import XCTest
@testable import Swirl

class SwirlTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: Image Class Tests
    // Confirm that the Image initializer returns a Meal object when passed valid parameters.
    func testImageInitializationSucceeds() {
        // Zero rating
        let zeroRatingImage = Image.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingImage)
        
        // Highest positive rating
        let positiveRatingImage = Image.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingImage)
    }
    
    // Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testImageInitializationFails() {
        // Negative rating
        let negativeRatingImage = Image.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingImage)
        
        // Rating exceeds maximum
        let largeRatingImage = Image.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingImage)
        
        // Empty String
        let emptyStringImage = Image.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringImage)
        
    }
    
}
