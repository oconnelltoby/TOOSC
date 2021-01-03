//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension Float32: OSCArgument {
    public enum ParsingError: Error {
        case dataTooShort
    }
    
    public var oscData: Data {
        withUnsafeBytes(of: bitPattern.bigEndian) { Data($0) }
    }
    
    private static let typeTag: TypeTag = "f"
    
    public var typeTag: TypeTag { Self.typeTag }
    
    public static let builders: [TypeTag: (Data, inout Int) throws -> OSCArgument] = [typeTag: build]
    
    public init(oscData: Data) throws {
        var index = 0
        self = try Self.build(oscData: oscData, index: &index)
    }
    
    public init(oscData: Data, index: inout Int) throws {
        self = try Self.build(oscData: oscData, index: &index)
    }
    
    static func build(oscData: Data, index: inout Int) throws -> Float32 {
        let size = MemoryLayout<Self>.size
        
        guard oscData.count >= size else {
            throw ParsingError.dataTooShort
        }
        
        let oscData = oscData.subdata(in: index ..< index + size)
        
        let bigEndian = oscData.withUnsafeBytes { $0.load(as: UInt32.self) }
        let bitPattern = UInt32(bigEndian: bigEndian)
        
        index += size
        return Float32(bitPattern: bitPattern)
    }
}
