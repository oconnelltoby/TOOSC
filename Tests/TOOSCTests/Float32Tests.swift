//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import XCTest
@testable import TOOSC

class Float32Tests: XCTestCase {
    private lazy var randomPairings = (0 ..< 10000)
        .map { _ -> (value: Float32, bytes: [UInt8]) in
            let sign = UInt32.random(in: .min ... .max) % 2
            let exponent = UInt32.random(in: .min ... .max) % (1 << 8)
            let mantissa = UInt32.random(in: .min ... .max) % (1 << 23)
            let bitPattern = sign << 32 + exponent << 31 + mantissa
            
            let value = Float32(bitPattern: bitPattern)
            let bytes = (0 ..< 4).reversed().map {
                UInt8((bitPattern >> ($0 * 8)) % (1 << 8))
            }
            return (value, bytes)
        }
    
    func testMaxFloat32ToOSCData() {
        XCTAssertEqual([UInt8](Float32.greatestFiniteMagnitude.oscData), [127, 127, 255, 255])
    }

    func testMinFloat32ToOSCData() {
        print(Float32.leastNormalMagnitude)
        XCTAssertEqual([UInt8](Float32.leastNormalMagnitude.oscData), [0, 128, 0, 0])
    }
    
    func testZeroToOSCData() {
        XCTAssertEqual([UInt8](Float32(0).oscData), [0, 0, 0, 0])
    }

    func testRandomFloat32sToOSCData() {
        randomPairings.forEach { value, bytes in
            XCTAssertEqual([UInt8](value.oscData), bytes)
        }
    }
    
    func testOSCDataToMinFloat32() throws {
        let value = try Float32(oscData: Data([0, 128, 0, 0]))
        XCTAssertEqual(value, Float32.leastNormalMagnitude)
    }
    
    func testOSCDataToMaxFloat32() throws {
        let value = try Float32(oscData: Data([127, 127, 255, 255]))
        XCTAssertEqual(value, Float32.greatestFiniteMagnitude)
    }
    
    func testOSCDataToZero() throws {
        let value = try Float32(oscData: Data([0, 0, 0, 0]))
        XCTAssertEqual(value, 0)
    }
    
    func testRandomOSCDataToFloat32() throws {
        try randomPairings.forEach { value, bytes in
            XCTAssertEqual(value, try Float32(oscData: Data(bytes)))
        }
    }
    
    func testIndexIsIncremented() throws {
        var index = 0
        _ = try Float32(oscData: Data([127, 255, 255, 255]), index: &index)
        XCTAssertEqual(index, 4)
    }
    
    func testNonZeroIndexedOSCDataToFloat32() throws {
        var index = 4
        let value = try Float32(oscData: Data([0, 128, 0, 0, 127, 127, 255, 255]), index: &index)
        XCTAssertEqual(value, Float32.greatestFiniteMagnitude)
        XCTAssertEqual(index, 8)
    }
    
    func testMisalignedOSCDataToFloat32() throws {
        var index = 1
        let value = try Float32(oscData: Data([0, 127, 127, 255, 255]), index: &index)
        XCTAssertEqual(value, Float32.greatestFiniteMagnitude)
    }
    
    func testDataTooShortThrows() throws {
        XCTAssertThrowsError(try Float32(oscData: Data([127, 255, 255]))) { error in
            XCTAssertEqual(error as? Float32.ParsingError, .dataTooShort)
        }
    }
}
