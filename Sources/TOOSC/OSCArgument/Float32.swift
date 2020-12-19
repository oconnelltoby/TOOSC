//
//  File.swift
//  
//
//  Created by Toby O'Connell on 09/12/2020.
//

import Foundation

extension Float32: OSCArgument {
    public static let typeTag: Character = "f"
    
    public var oscData: Data {
        withUnsafeBytes(of: bitPattern.bigEndian) { Data($0) }
    }
    
    public init?(oscData: Data, index: inout Int) {
        let size = MemoryLayout<Self>.size
        let oscData = oscData.subdata(in: index ..< index + size)
        guard oscData.count >= size else { return nil }
        
        
        let bigEndian = oscData.withUnsafeBytes { $0.load(as: UInt32.self) }
        let bitPattern = UInt32(bigEndian: bigEndian)
        self.init(bitPattern: bitPattern)
        index += size
    }
}
