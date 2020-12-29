//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import XCTest
@testable import TOOSC

class TimeTagTests: XCTestCase {
    func testMaxTimeTagToOSCData() {
        XCTAssertEqual([UInt8](TimeTag(ntpSeconds: .max).oscData), [255, 255, 255, 255, 255, 255, 255, 255])
    }

    func testMinTimeTagToOSCData() {
        XCTAssertEqual([UInt8](TimeTag(ntpSeconds: .min).oscData), [0, 0, 0, 0, 0, 0, 0, 0])
    }
    
    func testImmediateToOSCData() {
        XCTAssertEqual([UInt8](TimeTag.immediate.oscData), [0, 0, 0, 0, 0, 0, 0, 1])
    }
    
    func testOSCDataToMinTimeTag() throws {
        let value = try TimeTag(oscData: Data([0, 0, 0, 0, 0, 0, 0, 0]))
        XCTAssertEqual(value, TimeTag(ntpSeconds: .min))
    }
    
    func testOSCDataToMaxTimeTag() throws {
        let value = try TimeTag(oscData: Data([255, 255, 255, 255, 255, 255, 255, 255]))
        XCTAssertEqual(value, TimeTag(ntpSeconds: .max))
    }
    
    func testOSCDataToImmediateTimeTag() throws {
        let value = try TimeTag(oscData: Data([0, 0, 0, 0, 0, 0, 0, 1]))
        XCTAssertEqual(value, TimeTag.immediate)
    }

    func testIndexIsIncremented() throws {
        var index = 0
        _ = try TimeTag(oscData: Data([0, 0, 0, 0, 0, 0, 0, 1]), index: &index)
        XCTAssertEqual(index, 8)
    }
    
    func testDataTooShortThrows() throws {
        XCTAssertThrowsError(try TimeTag(oscData: Data([0, 0, 0, 0, 0, 0, 0]))) { error in
            XCTAssertEqual(error as? TimeTag.ParsingError, .dataTooShort)
        }
    }
}
