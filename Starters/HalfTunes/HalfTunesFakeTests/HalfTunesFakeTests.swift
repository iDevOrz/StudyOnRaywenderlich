//
//  HalfTunesFakeTests.swift
//  HalfTunesFakeTests
//
//  Created by 张建宇 on 2017/5/18.
//  Copyright © 2017年 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import HalfTunes

class HalfTunesFakeTests: XCTestCase {
    
    var controllerUnderTest: SearchViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controllerUnderTest = UIStoryboard(name: "Main",
                                           bundle: nil).instantiateInitialViewController() as! SearchViewController!
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        
        controllerUnderTest.defaultSession = sessionMock
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controllerUnderTest = nil
        super.tearDown()
    }
    
    // Fake URLSession with DHURLSession protocol and stubs
    func test_UpdateSearchResults_ParsesData() {
        // given
        let promise = expectation(description: "Status code: 200")
        
        // when
        XCTAssertEqual(controllerUnderTest?.searchResults.count, 0, "searchResults should be empty before the data task runs")
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let dataTask = controllerUnderTest?.defaultSession.dataTask(with: url!) {
            data, response, error in
            // if HTTP request is successful, call updateSearchResults(_:) which parses the response data into Tracks
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    promise.fulfill()
                    self.controllerUnderTest?.updateSearchResults(data)
                }
            }
        }
        dataTask?.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertEqual(controllerUnderTest?.searchResults.count, 3, "Didn't parse 3 items from fake response")
    }
    
    // Performance
    func test_StartDownload_Performance() {
        let track = Track(name: "Waterloo", artist: "ABBA",
                          previewUrl: "http://a821.phobos.apple.com/us/r30/Music/d7/ba/ce/mzm.vsyjlsff.aac.p.m4a")
        measure {
            self.controllerUnderTest?.startDownload(track)
        }
    }

}
