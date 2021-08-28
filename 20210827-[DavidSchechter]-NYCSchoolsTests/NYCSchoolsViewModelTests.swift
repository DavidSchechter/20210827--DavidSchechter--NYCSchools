//
//  NYCSchoolsViewModelTests.swift
//  20210827-[DavidSchechter]-NYCSchoolsTests
//
//  Created by David Schechter on 8/27/21.
//

import XCTest
import Combine
@testable import _0210827__DavidSchechter__NYCSchools

class NYCSchoolsViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testModelPublisher() throws {
        let sut = makeSut()
        let model = NYCHighSchool(dbn: "test")
        let modelExpectation = expectation(description: "model was set")
        sut.modelPublisher
            .dropFirst()
            .sink { schools in
                XCTAssertEqual(schools.first?.dbn, model.dbn)
                modelExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.modelPublisher.send([model])
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testFilteredPublisher() throws {
        let sut = makeSut()
        let model = NYCHighSchool(dbn: "test")
        let filteredExpectation = expectation(description: "filtered model was set")
        sut.filteredPublisher
            .dropFirst()
            .sink { schools in
                XCTAssertEqual(schools?.first?.dbn, model.dbn)
                filteredExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.filteredPublisher.send([model])
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testTitlePublisher() throws {
        let sut = makeSut()
        let value = "NYC High Schools"
        let titleExpectation = expectation(description: "title was set")
        sut.titlePublisher
            .sink { title in
                XCTAssertEqual(title, value)
                titleExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testGetData() throws {
        let sut = makeSut()
        let modelExpectation = expectation(description: "data was set")
        sut.modelPublisher
            .dropFirst()
            .sink { schools in
                XCTAssertEqual(schools.first?.dbn, "test")
                XCTAssertEqual(schools.first?.schoolName, "name")
                XCTAssertEqual(schools.first?.satCriticalReadingAvgScore, "88")
                modelExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.getData()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testFilterByName() throws {
        let sut = makeSut()
        let filteredExpectation = expectation(description: "filtered data was set")
        sut.filteredPublisher
            .dropFirst()
            .sink { schools in
                XCTAssertEqual(schools?.first?.schoolName, "name")
                filteredExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.getData()
        sut.filterByName("name")
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    //MARK:- Helper Methods
    
    func makeSut() -> NYCSchoolsViewModelProtocol {
        return NYCSchoolsViewModel(dataManager: makeDataManger())
    }
    
    func makeDataManger() -> DataManagerProtocol {
        return MockDataManager()
    }
    
    class MockDataManager: DataManagerProtocol {
        func getSchools(completion: @escaping ([NYCHighSchool]) -> Void, failure: @escaping (Error?) -> ()) {
            let model = NYCHighSchool(dbn: "test", schoolName: "name")
            completion([model])
        }
        
        func getSchoolsWithSATScores(completion: @escaping ([NYCHighSchool]) -> Void, failure: @escaping (Error?) -> ()) {
            let model = NYCHighSchool(dbn: "test", satCriticalReadingAvgScore: "88")
            completion([model])
        }
    }
}
