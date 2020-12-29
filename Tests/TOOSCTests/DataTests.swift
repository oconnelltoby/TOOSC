//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import XCTest
@testable import TOOSC

class DataTests: XCTestCase {
    func testEmptyDataToOSCData() {
        XCTAssertEqual([UInt8](Data().oscData), [0, 0, 0, 0])
    }
    
    func testDataToOSCData() {
        let data = Data("Hello, World!".utf8).oscData
        XCTAssertEqual([UInt8](data), [0, 0, 0, 13, 72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33, 0, 0, 0])
    }
    
    func testOSCDataToData() throws {
        let data = Data([0, 0, 0, 13, 72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33, 0, 0, 0])
        XCTAssertEqual(try Data(oscData: data), Data("Hello, World!".utf8))
    }

    func testIndexIsIncremented() throws {
        var index = 0
        let data = Data([0, 0, 0, 13, 72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33, 0, 0, 0])
        _ = try Data(oscData: data, index: &index)
        XCTAssertEqual(index, 20)
    }

    func testNonZeroIndexedOSCDataToData() throws {
        let data = Data([0, 0, 0, 13, 72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33, 0, 0, 0])
        var index = 20
        let value = try Data(oscData: data.reversed() + data, index: &index)
        XCTAssertEqual(value, Data("Hello, World!".utf8))
        XCTAssertEqual(index, 40)
    }
    
    func testNegativeSizeThrows() throws {
        XCTAssertThrowsError(try Data(oscData: Data([255, 255, 255, 255]))) { error in
            XCTAssertEqual(error as? Data.ParsingError, .invalidNegativeSize)
        }
    }

    func testUnableToParseSizeThrows() throws {
        XCTAssertThrowsError(try Data(oscData: Data([127, 255, 255]))) { error in
            XCTAssertEqual(error as? Data.ParsingError, .cannotParseSize(error: .dataTooShort))
        }
    }
    
    func testDataTooShortThrows() throws {
        XCTAssertThrowsError(try Data(oscData: Data([127, 255, 255, 255]))) { error in
            XCTAssertEqual(error as? Data.ParsingError, .dataTooShort)
        }
    }
}
