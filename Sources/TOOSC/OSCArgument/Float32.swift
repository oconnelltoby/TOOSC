//
//  File.swift
//  
//
//  Created by Toby O'Connell on 09/12/2020.
//

import Foundation

extension Float32: OSCArgument {
    static let typeTag: Character = "f"
    
    var oscData: Data {
        withUnsafeBytes(of: bitPattern.bigEndian) { Data($0) }
    }
    
    init?(oscData: Data, index: inout Int) {
        let size = MemoryLayout<Self>.size
        guard oscData.count >= size else { return nil }
        let searchData = oscData[index ..< index + size]
        
        
        let bigEndian = searchData.withUnsafeBytes { $0.load(as: UInt32.self) }
        let bitPattern = UInt32(bigEndian: bigEndian)
        self.init(bitPattern: bitPattern)
        index += size
    }
}
