//
//  File.swift
//  
//
//  Created by Toby O'Connell on 09/12/2020.
//

import Foundation

extension Data: OSCArgument {
    public static let typeTag: Character = "b"
    
    public var oscData: Data {
        let length = UInt32(count).bigEndian
        let lengthData = Swift.withUnsafeBytes(of: length) { Data($0) }
        return (lengthData + self).bytePadded(multiple: 4)
    }
    
    public init?(oscData: Data, index: inout Int) {
        guard let size = Int32(oscData: oscData, index: &index) else { return nil }
        let searchData = oscData[index ..< oscData.endIndex]
        guard searchData.count >= size else { return nil }
        self = searchData[index ..< index + Int(size)]
        index += Int(size).nextMultiple(of: 4)
    }
}
