//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

public protocol OSCArgument {
    typealias TypeTag = Character
    
    var typeTag: TypeTag { get }
    var oscData: Data { get }
    
    static var builders: [TypeTag: (_ oscData: Data, _ index: inout Int) throws -> OSCArgument] { get }
}
