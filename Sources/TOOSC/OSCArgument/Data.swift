//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension Data: OSCArgument {
    public enum ParsingError: Error, Equatable {
        case cannotParseSize(error: Int32.ParsingError)
        case dataTooShort
        case invalidNegativeSize
    }
    
    public var oscData: Data {
        let length = Int32(count).oscData
        return (length + self).bytePadded(multiple: 4)
    }
    
    private static let typeTag: TypeTag = "b"
    
    public var typeTag: TypeTag { Self.typeTag }
    
    public static let builders: [TypeTag: (Data, inout Int) throws -> OSCArgument] = [typeTag: build]
    
    public init(oscData: Data) throws {
        var index = 0
        self = try Self.build(oscData: oscData, index: &index)
    }
    
    public init(oscData: Data, index: inout Int) throws {
        self = try Self.build(oscData: oscData, index: &index)
    }
    
    private static func build(oscData: Data, index: inout Int) throws -> Data {
        let size: Int32
        do {
            try size = Int32(oscData: oscData, index: &index)
        } catch let error as Int32.ParsingError {
            throw ParsingError.cannotParseSize(error: error)
        }
        
        guard size > 0 else {
            throw ParsingError.invalidNegativeSize
        }

        guard oscData.count >= Int(size) + MemoryLayout.size(ofValue: size) else {
            throw ParsingError.dataTooShort
        }
        
        let data = oscData[index ..< index + Int(size)]
        index += Int(size).nextMultiple(of: 4)
        return data
    }
}
