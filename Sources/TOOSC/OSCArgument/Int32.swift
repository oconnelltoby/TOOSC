//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension Int32: OSCArgument {
    public enum ParsingError: Error {
        case dataTooShort
    }
    
    public static let typeTag: Character = "i"
    
    public var oscData: Data {
        withUnsafeBytes(of: bigEndian) { Data($0) }
    }
    
    public init(oscData: Data, index: inout Int) throws {
        let size = MemoryLayout<Self>.size
        guard oscData.count >= size else {
            throw ParsingError.dataTooShort
        }
        let oscData = oscData.subdata(in: index ..< index + size)
        
        self.init(bigEndian: oscData.withUnsafeBytes { $0.load(as: Int32.self) })
        index += size
    }
}
