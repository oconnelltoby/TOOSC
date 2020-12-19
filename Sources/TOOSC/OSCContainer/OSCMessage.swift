//
//  File.swift
//  
//
//  Created by Toby O'Connell on 05/12/2020.
//

import Foundation

public struct OSCMessage: OSCContainer {
    static var indentifier: String = "/"
    
    var address: String
    var arguments: [OSCArgument]
    
    public init(address: String, arguments: [OSCArgument]) {
        self.address = address
        self.arguments = arguments
    }
    
    public var oscData: Data {
        var typeTags = ","
        var argumentData = Data()

        arguments.forEach { argument in
            typeTags.append(type(of: argument).typeTag)
            argumentData.append(argument.oscData)
        }

        return address.oscData + typeTags.oscData + argumentData
    }

    public init?(oscData: Data, argumentBuilders: [Character: (_ oscData: Data, _ index: inout Int) -> OSCArgument?]) {
        var index = 0
        self.init(oscData: oscData, index: &index, argumentBuilders: argumentBuilders)
    }

    public init?(oscData: Data, index: inout Int, argumentBuilders: [Character: (_ oscData: Data, _ index: inout Int) -> OSCArgument?]) {
        let oscData = oscData[index ..< oscData.count]
        guard oscData.starts(with: Self.indentifier.utf8) else { return nil }

        guard let address = String(oscData: oscData, index: &index) else { return nil }
        self.address = address

        guard let typeTags = String(oscData: oscData, index: &index) else { return nil }
        guard typeTags.starts(with: ",") else { return nil }

        arguments = typeTags.dropFirst().compactMap { typeTag in
            argumentBuilders[typeTag]?(oscData, &index)
        }
    }
}
