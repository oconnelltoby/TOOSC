//
//  File.swift
//  
//
//  Created by Toby O'Connell on 05/12/2020.
//

import Foundation

extension String {
    var nullTerminatedBytes: Data {
        Data(utf8) + [UInt8(0)]
    }
}
