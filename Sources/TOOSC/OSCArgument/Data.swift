//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension Data: OSCArgument {
    public static let typeTag: Character = "b"
    
    public var oscData: Data {
        let length = Int32(count).bigEndian
        let lengthData = Swift.withUnsafeBytes(of: length) { Data($0) }
        return (lengthData + self).bytePadded(multiple: 4)
    }
    
    public init?(oscData: Data, index: inout Int) {
        guard let size = Int32(oscData: oscData, index: &index) else { return nil }
        guard oscData.count >= Int(size) + MemoryLayout.size(ofValue: size) else { return nil }
        let oscData = oscData[index ..< oscData.endIndex]
        self = oscData[index ..< index + Int(size)]
        index += Int(size).nextMultiple(of: 4)
    }
}
