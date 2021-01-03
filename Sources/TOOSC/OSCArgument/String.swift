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
    
    private static let nullTerminator = UInt8(0)
    
    public var oscData: Data {
        nullTerminatedBytes.bytePadded(multiple: 4)
    }
    
    private static let typeTag: TypeTag = "s"
    
    public var typeTag: TypeTag { Self.typeTag }
    
    public static let builders: [TypeTag: (Data, inout Int) throws -> OSCArgument] = [typeTag: build]
    
    public init(oscData: Data) throws {
        var index = 0
        self = try Self.build(oscData: oscData, index: &index)
    }
    
    public init(oscData: Data, index: inout Int) throws {
        self = try Self.build(oscData: oscData, index: &index)
    }
    
    static func build(oscData: Data, index: inout Int) throws -> String {
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
        
        index += (oscData.count + MemoryLayout.size(ofValue: Self.nullTerminator)).nextMultiple(of: 4)
        return string
    }
}
