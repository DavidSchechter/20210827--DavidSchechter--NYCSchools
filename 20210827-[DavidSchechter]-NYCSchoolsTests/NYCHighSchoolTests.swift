//
//  NYCHighSchoolTests.swift
//  20210827-[DavidSchechter]-NYCSchoolsTests
//
//  Created by David Schechter on 8/27/21.
//

import XCTest
@testable import _0210827__DavidSchechter__NYCSchools

class NYCHighSchoolTests: XCTestCase {

    func testDefaultInit() throws {
        let model = NYCHighSchool()
        
        XCTAssertNil(model.dbn)
    }
    
    func testInit() throws {
        let value = "test"
        let model = NYCHighSchool(dbn: value, schoolName: value, overviewParagraph: value, location: value, website: value, phoneNumber: value, satCriticalReadingAvgScore: value, satMathAvgScore: value, satWritinAvgScore: value)
        
        XCTAssertEqual(model.dbn, value)
        XCTAssertEqual(model.schoolName, value)
    }
    
    func testMerge() throws {
        let value1 = "test1"
        let model1 = NYCHighSchool(dbn: value1, schoolName: value1, overviewParagraph: nil, location: nil, website: value1, phoneNumber: value1, satCriticalReadingAvgScore: value1, satMathAvgScore: nil, satWritinAvgScore: nil)
        let value2 = "test2"
        let model2 = NYCHighSchool(dbn: nil, schoolName: nil, overviewParagraph: value2, location: value2, website: nil, phoneNumber: nil, satCriticalReadingAvgScore: nil, satMathAvgScore: nil, satWritinAvgScore: value2)
        let model3 = model1.merge(model2)
        
        XCTAssertEqual(model3.dbn, value1)
        XCTAssertEqual(model3.schoolName, value1)
        XCTAssertEqual(model3.overviewParagraph, value2)
        XCTAssertEqual(model3.location, value2)
        XCTAssertEqual(model3.satMathAvgScore, nil)
        XCTAssertEqual(model3.satWritinAvgScore, value2)
        
    }
    
    func testLocationWithoutCoordinate() throws {
        let value = "address (40.6971494,-74.259867)"
        let model = NYCHighSchool(location: value)
        
        XCTAssertEqual(model.locationWithoutCoordinate(), "address ")
    }
    
    func testLocationWithCoordinate() throws {
        let value = "address (40.6971494,-74.259867)"
        let model = NYCHighSchool(location: value)
        
        XCTAssertEqual(model.locationWithCoordinate()?.latitude, 40.6971494)
        XCTAssertEqual(model.locationWithCoordinate()?.longitude, -74.259867)
    }
}
