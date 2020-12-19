//
//  File.swift
//  
//
//  Created by Toby O'Connell on 09/12/2020.
//

import Foundation

extension Array where Element == OSCArgument.Type {
    public static let `default`: Self = [Float32.self, Int32.self, Data.self, String.self, TimeTag.self]
}

extension Dictionary where Key == Character, Value == (_ oscData: Data, _ index: inout Int) -> OSCArgument? {
    init(types: [OSCArgument.Type]) {
        self = types.reduce(into: Self()) { (dictionary, oscArgumentType) in
            dictionary[oscArgumentType.typeTag] = oscArgumentType.init
        }
    }
    
    public static let `default`: Self = .init(types: .default)
}

