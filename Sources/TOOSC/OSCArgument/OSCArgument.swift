//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

public protocol OSCArgument {
    static var typeTag: Character { get }
    init?(oscData: Data, index: inout Int)
    var oscData: Data { get }
}
