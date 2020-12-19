//
//  File.swift
//  
//
//  Created by Toby O'Connell on 19/12/2020.
//

extension TimeTag: Equatable {
    public static func == (lhs: TimeTag, rhs: TimeTag) -> Bool {
        lhs.ntpSeconds == rhs.ntpSeconds
    }

}
