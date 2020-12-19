//
//  File.swift
//  
//
//  Created by Toby O'Connell on 19/12/2020.
//

import Foundation

protocol OSCContainer {
    static var indentifier: String { get }
    
    init?(
        oscData: Data,
        index: inout Int,
        argumentBuilders: [Character: (_ oscData: Data, _ index: inout Int) -> OSCArgument?]
    )
    
    var oscData: Data { get }
}
