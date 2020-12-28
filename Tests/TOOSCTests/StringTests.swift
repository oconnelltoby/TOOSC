//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import XCTest
@testable import TOOSC

class StringTests: XCTestCase {
    func testStringToOSCData() {
        let value = UUID().uuidString
        let bytes = value.utf8 + Array(repeating: 0, count: 4)
        
        XCTAssertEqual(bytes.count % 4, 0)
        XCTAssertEqual([UInt8](value.oscData), bytes)
    }
    
    func testEmptyStringToOSCDataHasFourBytes() {
        let value = ""
        let bytes = [UInt8](repeating: 0, count: 4)
        
        XCTAssertEqual(bytes.count % 4, 0)
        XCTAssertEqual([UInt8](value.oscData), bytes)
    }
    
    func testOSCDataToString() throws {
        let data = Data([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33, 0, 0, 0])
        let value = try String(oscData: data)
        
        XCTAssertEqual(value, "Hello, World!")
    }

    func testIndexIsIncremented() throws {
        var index = 0
        let data = Data([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33, 0, 0, 0])
        _ = try String(oscData: data, index: &index)
        
        XCTAssertEqual(index, 16)
    }
    
    func testEmptyStringOSCDataToString() throws {
        let value = try String(oscData: Data([0, 0, 0, 0]))
        XCTAssertEqual(value, "")
    }

    func testNonZeroIndexedOSCDataToString() throws {
        var index = 1
        let value = try String(oscData: Data([17, 97, 0, 0, 0]), index: &index)
        XCTAssertEqual(value, "a")
        XCTAssertEqual(index, 5)
    }
    
    func testDataTooShortThrows() throws {
        XCTAssertThrowsError(try String(oscData: Data([97, 0, 0]))) { error in
            XCTAssertEqual(error as? String.ParsingError, .dataTooShort)
        }
    }

    func testLeadingNullTerminatorThrows() throws {
        XCTAssertThrowsError(try String(oscData: Data([0, 97, 0, 0, 0]))) { error in
            XCTAssertEqual(error as? String.ParsingError, .invalidLeadingNullTerminator)
        }
    }
    
    func testMissingNullTerminatorThrows() throws {
        XCTAssertThrowsError(try String(oscData: Data([97, 97, 97, 97]))) { error in
            XCTAssertEqual(error as? String.ParsingError, .missingNullTerminator)
        }
    }
    
    func testInvalidUTF8DataThrows() throws {
        XCTAssertThrowsError(try String(oscData: Data([195, 40, 0, 0]))) { error in
            XCTAssertEqual(error as? String.ParsingError, .invalidUTF8Encoding)
        }
    }
}
