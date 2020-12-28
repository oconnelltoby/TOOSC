//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension String: OSCArgument {
    public enum ParsingError: Error {
        case missingNullTerminator
        case invalidUTF8Encoding
        case dataTooShort
        case invalidLeadingNullTerminator
    }
    
    public static let typeTag: Character = "s"
    private static let nullTerminator = UInt8(0)
    
    public var oscData: Data {
        nullTerminatedBytes.bytePadded(multiple: 4)
    }
    
    public init(oscData: Data, index: inout Int) throws {
        guard let nullTerminatorPosition = oscData[index ..< oscData.endIndex].firstIndex(of: Self.nullTerminator) else {
            throw ParsingError.missingNullTerminator
        }
        
        if oscData.count < 4 {
            throw ParsingError.dataTooShort
        }
        
        if oscData.count > 4, oscData.first == Self.nullTerminator {
            throw ParsingError.invalidLeadingNullTerminator
        }
        
        let oscData = oscData[index ..< nullTerminatorPosition]
        
        guard let string = String(data: oscData, encoding: .utf8) else {
            throw ParsingError.invalidUTF8Encoding
        }
        
        self = string
        index += (oscData.count + MemoryLayout.size(ofValue: Self.nullTerminator)).nextMultiple(of: 4)
    }
}
