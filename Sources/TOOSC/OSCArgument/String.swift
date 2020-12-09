//
//  File.swift
//  
//
//  Created by Toby O'Connell on 09/12/2020.
//

import Foundation

extension String: OSCArgument {
    static let typeTag: Character = "s"
    
    var oscData: Data {
        nullTerminatedBytes.bytePadded(multiple: 4)
    }
    
    init?(oscData: Data, index: inout Int) {
        let searchData = oscData[index ..< oscData.endIndex]
        let stringData = searchData.prefix { $0 != 0 }
        
        self.init(data: stringData, encoding: .utf8)
        let nullTerminatorSize = 1
        index += (stringData.count + nullTerminatorSize).nextMultiple(of: 4)
    }
}
