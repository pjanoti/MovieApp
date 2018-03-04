//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by prema janoti on 3/1/18.
//  Copyright © 2018 prema. All rights reserved.
//

import XCTest
@testable import MovieApp


class MovieAppTests: XCTestCase {
    var sessionUnderTest: URLSession!
   
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
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
    func testAPICall() {
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sessionUnderTest.dataTask(with: baseUrl!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
    func testGetDataWithSuccess()  {
        let promise = expectation(description: "Status code: 200")
        let apiClient = APIClient()
        apiClient.getDataWith { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data, "Result is success")
                 promise.fulfill()
            case .error(let error):
              XCTAssertNil(error, "error is nil")
            }
        }
        waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
   
}
