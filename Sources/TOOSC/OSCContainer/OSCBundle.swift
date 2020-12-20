//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

public struct OSCBundle: Equatable {
    public static func == (lhs: OSCBundle, rhs: OSCBundle) -> Bool {
        lhs.oscData == rhs.oscData
    }
    
    public enum Content {
        case bundle(OSCBundle)
        case message(OSCMessage)
        
        var oscData: Data {
            switch self {
            case let .bundle(bundle):
                return bundle.oscData
            case let .message(message):
                return message.oscData
            }
        }
    }
    
    var timeTag: TimeTag
    var content: [Content]
    
    public init(timeTag: TimeTag, content: [Content]) {
        self.content = content
        self.timeTag = timeTag
    }
    
    public init?(
        oscData: Data,
        argumentBuilders: [Character: (_ oscData: Data, _ index: inout Int) -> OSCArgument?]
    ) {
        var index = 0
        self.init(oscData: oscData, index: &index, argumentBuilders: argumentBuilders)
    }

    public init?(
        oscData: Data,
        index: inout Int,
        argumentBuilders: [Character: (_ oscData: Data, _ index: inout Int) -> OSCArgument?]
    ) {
        guard String(oscData: oscData, index: &index) == "#bundle" else { return nil }

        guard let timeTag = TimeTag(oscData: oscData, index: &index) else { return nil }
        self.timeTag = timeTag

        guard let size = Int32(oscData: oscData, index: &index) else { return nil }
        let end = index + Int(size)
        
        content = []

        while index < end {
            if let message = OSCMessage(oscData: oscData, index: &index, argumentBuilders: argumentBuilders) {
                content.append(.message(message))
                continue
            }

            if let bundle = OSCBundle(oscData: oscData, index: &index, argumentBuilders: argumentBuilders) {
                content.append(.bundle(bundle))
                continue
            }
            
            return
        }
    }
    
    public var oscData: Data {
        let contentData = content.reduce(into: Data()) {
            $0 += $1.oscData
        }
        let length = Int32(contentData.count).bigEndian
        let lengthData = withUnsafeBytes(of: length) { Data($0) }
        
        return "#bundle".oscData + timeTag.oscData + lengthData + contentData
    }
}
