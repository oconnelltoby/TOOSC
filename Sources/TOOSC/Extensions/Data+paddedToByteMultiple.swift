//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension Data {
    func bytePadded(multiple: Int) -> Data {
        return self + (count ..< count.nextMultiple(of: multiple)).map { _ in UInt8(0) }
    }
}
