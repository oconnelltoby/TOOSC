//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

public struct TimeTag {
    public enum ParsingError: Error {
        case dataTooShort
    }
        
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
    
    public init(oscData: Data) throws {
        var index = 0
        try self.init(oscData: oscData, index: &index)
    }

    public init(oscData: Data, index: inout Int) throws {
        let size = MemoryLayout<UInt64>.size
        guard oscData.count >= size else {
            throw ParsingError.dataTooShort
        }
        let oscData = oscData.subdata(in: index ..< index + size)
        
        let ntpSeconds = UInt64(bigEndian: oscData.withUnsafeBytes { $0.load(as: UInt64.self) })
        self.init(ntpSeconds: ntpSeconds)
        index += size
    }
    
    public var oscData: Data {
        withUnsafeBytes(of: ntpSeconds.bigEndian) { Data($0) }
    }
}
