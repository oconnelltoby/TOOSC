//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension Int32: OSCArgument {
    public enum ParsingError: Error {
        case dataTooShort
    }
    
    public var oscData: Data {
        withUnsafeBytes(of: bigEndian) { Data($0) }
    }
    
    private static let typeTag: TypeTag = "i"
    
    public var typeTag: TypeTag { Self.typeTag }
    
    public static let builders: [TypeTag: (Data, inout Int) throws -> OSCArgument] = [typeTag: build]
    
    public init(oscData: Data) throws {
        var index = 0
        self = try Self.build(oscData: oscData, index: &index)
    }
    
    public init(oscData: Data, index: inout Int) throws {
        self = try Self.build(oscData: oscData, index: &index)
    }
    
    private static func build(oscData: Data, index: inout Int) throws -> Self {
        let size = MemoryLayout<Self>.size
        guard oscData.count >= size else {
            throw ParsingError.dataTooShort
        }
        let oscData = oscData.subdata(in: index ..< index + size)
        let bigEndian = oscData.withUnsafeBytes { $0.load(as: Int32.self) }
        index += size
        return Int32(bigEndian: bigEndian)
    }
}
