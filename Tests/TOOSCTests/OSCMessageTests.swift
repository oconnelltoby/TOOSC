//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import XCTest
@testable import TOOSC

class OSCMessageTests: XCTestCase {
    func testOSCMessageConversion() throws {
        let arguments: [OSCArgument] = ["Hello", Float32(12.5), Int32(-7), Data("World".utf8), TimeTag.immediate]
        let message = OSCMessage(address: "/a/b/c", arguments: arguments)
        let data = message.oscData
        let decoded = try XCTUnwrap(OSCMessage(oscData: data, argumentBuilders: .default))
        
        XCTAssertEqual(message, decoded)
    }
}
