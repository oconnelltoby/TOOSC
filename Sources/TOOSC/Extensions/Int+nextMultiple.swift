//
//  File.swift
//  
//
//  Created by Toby O'Connell on 09/12/2020.
//

extension Int {
    func nextMultiple(of multiple: Int) -> Int {
        (self + multiple - 1) / multiple * multiple
    }
}
