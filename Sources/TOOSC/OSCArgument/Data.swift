//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension Data: OSCArgument {
    public enum ParsingError: Error {
        case cannotParseSize(error: Error)
        case dataTooShort
    }
    
    public static let typeTag: Character = "b"
    
    public var oscData: Data {
        let length = Int32(count).bigEndian
        let lengthData = Swift.withUnsafeBytes(of: length) { Data($0) }
        return (lengthData + self).bytePadded(multiple: 4)
    }
    
    public init(oscData: Data, index: inout Int) throws {
        let size: Int32
        do {
            try size = Int32(oscData: oscData, index: &index)
        } catch {
            throw ParsingError.cannotParseSize(error: error)
        }

        guard oscData.count >= Int(size) + MemoryLayout.size(ofValue: size) else {
            throw ParsingError.dataTooShort
        }
        
        self = oscData[index ..< index + Int(size)]
        index += Int(size).nextMultiple(of: 4)
    }
}
