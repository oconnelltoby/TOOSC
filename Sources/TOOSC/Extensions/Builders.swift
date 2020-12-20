//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

public extension Array where Element == OSCArgument.Type {
    static let `default`: Self = [Float32.self, Int32.self, Data.self, String.self, TimeTag.self]
}

extension Dictionary where Key == Character, Value == (_ oscData: Data, _ index: inout Int) -> OSCArgument? {
    init(types: [OSCArgument.Type]) {
        self = types.reduce(into: Self()) { dictionary, oscArgumentType in
            dictionary[oscArgumentType.typeTag] = oscArgumentType.init
        }
    }
    
    public static let `default`: Self = .init(types: .default)
}
