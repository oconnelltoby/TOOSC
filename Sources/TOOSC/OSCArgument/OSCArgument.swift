//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

public protocol OSCArgument {
    static var typeTag: Character { get }
    init(oscData: Data, index: inout Int) throws
    var oscData: Data { get }
}

public extension OSCArgument {
    init(oscData: Data) throws {
        var index = 0
        try self.init(oscData: oscData, index: &index)
    }
}
