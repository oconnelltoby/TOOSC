//
//  File.swift
//  
//
//  Created by Toby O'Connell on 19/12/2020.
//

import Foundation

public struct TimeTag: OSCArgument {
    public static var typeTag: Character = "t"
    
    var ntpSeconds: UInt64
    
    public static let immediate = TimeTag(wholeSeconds: 0, fractionalSeconds: 1)
    
    public init(seconds: Double) {
        let wholeSeconds = UInt32(seconds)
        let fractionalSeconds = UInt32(MemoryLayout<UInt32>.size) * UInt32(seconds.remainder(dividingBy: 1))
        self.init(wholeSeconds: wholeSeconds, fractionalSeconds: fractionalSeconds)
    }
    
    public init(ntpSeconds: UInt64) {
        self.ntpSeconds = ntpSeconds
    }
    
    public init(wholeSeconds: UInt32, fractionalSeconds: UInt32) {
        ntpSeconds = UInt64(wholeSeconds) << MemoryLayout<UInt32>.size + UInt64(fractionalSeconds)
    }
    
    public init?(oscData: Data, index: inout Int) {
        let size = MemoryLayout<UInt64>.size
        guard oscData.count >= size else { return nil }
        let oscData = oscData[index ..< index + size]
        
        let ntpSeconds = UInt64(bigEndian: oscData.withUnsafeBytes { $0.load(as: UInt64.self) })
        self.init(ntpSeconds: ntpSeconds)
        index += size
    }
    
    public var oscData: Data {
        withUnsafeBytes(of: ntpSeconds.bigEndian) { Data($0) }
    }
}
