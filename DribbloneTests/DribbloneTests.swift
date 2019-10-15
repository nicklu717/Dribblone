//
//  DribbloneTests.swift
//  DribbloneTests
//
//  Created by 陸瑋恩 on 2019/10/15.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import XCTest
@testable import Dribblone

class DribbloneTests: XCTestCase {

    override func setUp() {
        
        super.setUp()
    }

    override func tearDown() {
        
        super.tearDown()
    }
    
    func testDateConvertToStringInResultDisplay() {
        
        let date = Date(timeIntervalSince1970: 1571153787)
        
        let dateString = date.string(format: .resultDisplay)
        
        XCTAssertEqual(dateString, "Oct-15 23:36")
    }
    
    func testCalculationOfCGRectCenter() {
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
        
        XCTAssertEqual(rect.center, CGPoint(x: 50, y: 100))
    }
}
