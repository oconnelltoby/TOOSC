//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

extension String {
    var nullTerminatedBytes: Data {
        Data(utf8) + [UInt8(0)]
    }
}
