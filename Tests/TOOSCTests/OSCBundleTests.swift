//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import XCTest
@testable import TOOSC

class OSCBundleTests: XCTestCase {
    func testOSCBundleConversion() throws {
        let content = (0 ..< 1).flatMap { _ -> [OSCBundle.Content] in
            [.message(randomMessage()), .bundle(randomBundle())]
        }
        
        let bundle = OSCBundle(timeTag: .immediate, content: content)
        
        let data = bundle.oscData
        let decoded = try XCTUnwrap(OSCBundle(oscData: data, argumentBuilders: .default))
        
        XCTAssertEqual(bundle, decoded)
    }
    
    private func randomArguments() -> [OSCArgument] {
        [
            UUID().uuidString,
            Float32.random(in: Float32.leastNormalMagnitude ... Float32.greatestFiniteMagnitude),
            Int32.random(in: Int32.min ... Int32.max),
            Data(UUID().uuidString.utf8),
        ]
    }
    
    private func randomMessage() -> OSCMessage {
        OSCMessage(address: "/\(UUID().uuidString)", arguments: randomArguments())
    }
    
    private func randomBundle() -> OSCBundle {
        OSCBundle(timeTag: randomTimeTag(), content: (0 ..< 5).map { _ in .message(randomMessage()) })
    }
    
    private func randomTimeTag() -> TimeTag {
        TimeTag(ntpSeconds: UInt64.random(in: UInt64.min ... UInt64.max))
    }
}
