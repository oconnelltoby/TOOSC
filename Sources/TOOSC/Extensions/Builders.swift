//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

public extension Array where Element == OSCArgument.Type {
    static let `default`: Self = [Float32.self, Int32.self, Data.self, String.self]
}

extension Dictionary where Key == Character, Value == (_ oscData: Data, _ index: inout Int) throws -> OSCArgument {
    init(types: [OSCArgument.Type]) {
        self = types.reduce(into: Self()) { dictionary, oscArgumentType in
            oscArgumentType.builders.forEach { typeTag, builder in
                dictionary[typeTag] = builder
            }
        }
    }
    
    public static let `default`: Self = .init(types: .default)
}
