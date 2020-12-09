//
//  File.swift
//  
//
//  Created by Toby O'Connell on 05/12/2020.
//

import Foundation

struct OSCMessage: Equatable {
    static func == (lhs: OSCMessage, rhs: OSCMessage) -> Bool {
        lhs.oscData == rhs.oscData
    }
    
    var address: String
    var arguments: [OSCArgument]
    
    init(address: String, arguments: [OSCArgument]) {
        self.address = address
        self.arguments = arguments
    }
    
    var oscData: Data {
        var typeTags = ","
        var argumentData = Data()

        arguments.forEach { argument in
            typeTags.append(type(of: argument).typeTag)
            argumentData.append(argument.oscData)
        }

        return address.oscData + typeTags.oscData + argumentData
    }

    init?(oscData: Data, argumentBuilders: [Character: (_ oscData: Data, _ index: inout Int) -> OSCArgument?]) {
        guard oscData.starts(with: "/".utf8) else { return nil }

        var index = 0

        guard let address = String(oscData: oscData, index: &index) else { return nil }
        self.address = address

        guard let typeTags = String(oscData: oscData, index: &index) else { return nil }
        guard typeTags.starts(with: ",") else { return nil }

        arguments = typeTags.dropFirst().compactMap { typeTag in
            argumentBuilders[typeTag]?(oscData, &index)
        }
    }
}
