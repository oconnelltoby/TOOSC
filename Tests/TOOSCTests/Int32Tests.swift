//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import XCTest
@testable import TOOSC

class Int32Tests: XCTestCase {
    private lazy var randomPairings = (0 ..< 10000)
        .map { _ -> (value: Int32, bytes: [UInt8]) in
            let bitPattern = UInt32.random(in: .min ... .max)
            let value = Int32(bitPattern: bitPattern)
            let bytes = (0 ..< 4).reversed().map {
                UInt8((bitPattern >> ($0 * 8)) % (1 << 8))
            }
            return (value, bytes)
        }
    
    func testMaxInt32ToOSCData() {
        XCTAssertEqual([UInt8](Int32.max.oscData), [127, 255, 255, 255])
    }

    func testMinInt32ToOSCData() {
        XCTAssertEqual([UInt8](Int32.min.oscData), [128, 0, 0, 0])
    }
    
    func testZeroToOSCData() {
        XCTAssertEqual([UInt8](Int32(0).oscData), [0, 0, 0, 0])
    }

    func testRandomInt32sToOSCData() {
        randomPairings.forEach { value, bytes in
            XCTAssertEqual([UInt8](value.oscData), bytes)
        }
    }
    
    func testOSCDataToMinInt32() throws {
        let value = try Int32(oscData: Data([128, 0, 0, 0]))
        XCTAssertEqual(value, Int32.min)
    }
    
    func testOSCDataToMaxInt32() throws {
        let value = try Int32(oscData: Data([127, 255, 255, 255]))
        XCTAssertEqual(value, Int32.max)
    }
    
    func testOSCDataToZero() throws {
        let value = try Int32(oscData: Data([0, 0, 0, 0]))
        XCTAssertEqual(value, 0)
    }
    
    func testRandomOSCDataToInt32() throws {
        try randomPairings.forEach { value, bytes in
            XCTAssertEqual(value, try Int32(oscData: Data(bytes)))
        }
    }
    
    func testIndexIsIncremented() throws {
        var index = 0
        _ = try Int32(oscData: Data([127, 255, 255, 255]), index: &index)
        XCTAssertEqual(index, 4)
    }
    
    func testNonZeroIndexedOSCDataToInt32() throws {
        var index = 4
        let value = try Int32(oscData: Data([128, 0, 0, 0, 127, 255, 255, 255]), index: &index)
        XCTAssertEqual(value, Int32.max)
        XCTAssertEqual(index, 8)
    }
    
    func testMisalignedOSCDataToInt32() throws {
        var index = 1
        let value = try Int32(oscData: Data([0, 127, 255, 255, 255]), index: &index)
        XCTAssertEqual(value, Int32.max)
    }
    
    func testDataTooShortThrows() throws {
        XCTAssertThrowsError(try Int32(oscData: Data([127, 255, 255]))) { error in
            XCTAssertEqual(error as? Int32.ParsingError, .dataTooShort)
        }
    }
}
