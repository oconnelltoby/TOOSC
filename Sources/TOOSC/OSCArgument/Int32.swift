//
//  File.swift
//  
//
//  Created by Toby O'Connell on 09/12/2020.
//

import Foundation

extension Int32: OSCArgument {
    public static let typeTag: Character = "i"
    
    public var oscData: Data {
        withUnsafeBytes(of: bigEndian) { Data($0) }
    }
    
    public init?(oscData: Data, index: inout Int) {
        let size = MemoryLayout<Self>.size
        let oscData = oscData.subdata(in: index ..< index + size)
        guard oscData.count >= size else { return nil }
        
        self.init(bigEndian: oscData.withUnsafeBytes { $0.load(as: Int32.self) })
        index += size
    }
}
