//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension String: OSCArgument {
    public static let typeTag: Character = "s"
    
    public var oscData: Data {
        nullTerminatedBytes.bytePadded(multiple: 4)
    }
    
    public init?(oscData: Data, index: inout Int) {
        let oscData = oscData[index ..< oscData.endIndex]
        let stringData = oscData.prefix { $0 != 0 }
        
        self.init(data: stringData, encoding: .utf8)
        let nullTerminatorSize = 1
        index += (stringData.count + nullTerminatorSize).nextMultiple(of: 4)
    }
}
