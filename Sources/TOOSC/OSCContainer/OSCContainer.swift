//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

protocol OSCContainer {
    static var indentifier: String { get }
    
    init(
        oscData: Data,
        index: inout Int,
        argumentBuilders: [Character: (_ oscData: Data, _ index: inout Int) throws -> OSCArgument]
    ) throws
    
    var oscData: Data { get }
}
