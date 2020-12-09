//
//  File.swift
//  
//
//  Created by Toby O'Connell on 05/12/2020.
//

import Foundation

extension Data {
    func bytePadded(multiple: Int) -> Data {
        return self + (count ..< count.nextMultiple(of: 4)).map { _ in UInt8(0) }
    }
}
