//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import XCTest
@testable import TOOSC

class DataConversionTests: XCTestCase {
    func testStringConversion() {
        XCTAssertEqual("tests".oscData, Data([116, 101, 115, 116, 115, 0, 0, 0]))
        XCTAssertEqual("test".oscData, Data([116, 101, 115, 116, 0, 0, 0, 0]))
        XCTAssertEqual("tes".oscData, Data([116, 101, 115, 0]))
        
        assertEqual(oscDataConstructable: "tests", data: Data([116, 101, 115, 116, 115, 0, 0, 0]), stride: 8)
        assertEqual(oscDataConstructable: "test", data: Data([116, 101, 115, 116, 0, 0, 0, 0]), stride: 8)
        assertEqual(oscDataConstructable: "tes", data: Data([116, 101, 115, 0]), stride: 4)
    }
    
    func testInt32Conversion() {
        XCTAssertEqual(Int32(2147417596).oscData, Data([127, 254, 253, 252]))
        XCTAssertEqual(Int32.max.oscData, Data([127, 255, 255, 255]))
        XCTAssertEqual(Int32.min.oscData, Data([128, 0, 0, 0]))
        
        assertEqual(oscDataConstructable: Int32(2147417596), data: Data([127, 254, 253, 252]), stride: 4)
        assertEqual(oscDataConstructable: Int32.max, data: Data([127, 255, 255, 255]), stride: 4)
        assertEqual(oscDataConstructable: Int32.min, data: Data([128, 0, 0, 0]), stride: 4)
    }
    
    func testFloat32Conversion() {
        XCTAssertEqual([UInt8](Float32(0).oscData), [0, 0, 0, 0])
        XCTAssertEqual([UInt8](Float32(1).oscData), [63, 128, 0, 0])
        XCTAssertEqual([UInt8](Float32(99999).oscData), [71, 195, 79, 128])
        XCTAssertEqual([UInt8](Float32(99998).oscData), [71, 195, 79, 0])
        XCTAssertEqual([UInt8](Float32(99997).oscData), [71, 195, 78, 128])
        
        assertEqual(oscDataConstructable: Float32(0), data: Data([0, 0, 0, 0]), stride: 4)
        assertEqual(oscDataConstructable: Float32(1), data: Data([63, 128, 0, 0]), stride: 4)
        assertEqual(oscDataConstructable: Float32(99999), data: Data([71, 195, 79, 128]), stride: 4)
        assertEqual(oscDataConstructable: Float32(99998), data: Data([71, 195, 79, 0]), stride: 4)
        assertEqual(oscDataConstructable: Float32(99997), data: Data([71, 195, 78, 128]), stride: 4)
    }
    
    func testDataConversion() {
        XCTAssertEqual(Data([0, 1, 2]).oscData, Data([0, 0, 0, 3, 0, 1, 2, 0]))
        XCTAssertEqual(Data([0, 1, 2, 3]).oscData, Data([0, 0, 0, 4, 0, 1, 2, 3]))
        XCTAssertEqual(Data([0, 1, 2, 3, 4]).oscData, Data([0, 0, 0, 5, 0, 1, 2, 3, 4, 0, 0, 0]))
        
        assertEqual(oscDataConstructable: Data([0, 1, 2]), data: Data([0, 0, 0, 3, 0, 1, 2, 0]), stride: 8)
        assertEqual(oscDataConstructable: Data([0, 1, 2, 3]), data: Data([0, 0, 0, 4, 0, 1, 2, 3]), stride: 8)
        assertEqual(oscDataConstructable: Data([0, 1, 2, 3, 4]), data: Data([0, 0, 0, 5, 0, 1, 2, 3, 4, 0, 0, 0]), stride: 12)
    }
    
    func testTimeTagConversion() throws {
        XCTAssertEqual([0, 0, 0, 0, 0, 0, 0, 1], [UInt8](TimeTag.immediate.oscData))
        XCTAssertEqual([0, 0, 0, 0, 0, 244, 35, 240], [UInt8](TimeTag(seconds: 999999).oscData))
        XCTAssertEqual([255, 255, 255, 255, 255, 255, 255, 255], [UInt8](TimeTag(ntpSeconds: UInt64.max).oscData))
        
        do {
            var index = 0
            XCTAssertEqual(try TimeTag(oscData: Data([0, 0, 0, 0, 0, 0, 0, 1]), index: &index), TimeTag.immediate)
            XCTAssertEqual(index, 8)
        }
        do {
            var index = 0
            XCTAssertEqual(try TimeTag(oscData: Data([0, 0, 0, 0, 0, 244, 35, 240]), index: &index), TimeTag(seconds: 999999))
            XCTAssertEqual(index, 8)
        }
        do {
            var index = 0
            XCTAssertEqual(try TimeTag(oscData: Data([255, 255, 255, 255, 255, 255, 255, 255]), index: &index), TimeTag(ntpSeconds: UInt64.max))
            XCTAssertEqual(index, 8)
        }
    }
}

extension DataConversionTests {
    private func assertEqual<Type>(
        oscDataConstructable: Type,
        data: Data,
        stride: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) where Type: OSCArgument & Equatable {
        var index = 0
        XCTAssertEqual(oscDataConstructable, try? Type(oscData: data, index: &index), file: file, line: line)
        XCTAssertEqual(index, stride, file: file, line: line)
    }
}
