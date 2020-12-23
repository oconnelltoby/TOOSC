//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension Float32: OSCArgument {
    public enum ParsingError: Error {
        case dataTooShort
    }
    
    public static let typeTag: Character = "f"
    
    public var oscData: Data {
        withUnsafeBytes(of: bitPattern.bigEndian) { Data($0) }
    }
    
    public init(oscData: Data, index: inout Int) throws {
        let size = MemoryLayout<Self>.size
        
        guard oscData.count >= size else {
            throw ParsingError.dataTooShort
        }
        
        let oscData = oscData.subdata(in: index ..< index + size)
        
        let bigEndian = oscData.withUnsafeBytes { $0.load(as: UInt32.self) }
        let bitPattern = UInt32(bigEndian: bigEndian)
        self.init(bitPattern: bitPattern)
        
        index += size
    }
}
