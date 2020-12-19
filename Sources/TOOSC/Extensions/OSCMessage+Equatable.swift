//
//  File.swift
//  
//
//  Created by Toby O'Connell on 19/12/2020.
//

extension OSCMessage: Equatable {
    public static func == (lhs: OSCMessage, rhs: OSCMessage) -> Bool {
        lhs.oscData == rhs.oscData
    }
}
