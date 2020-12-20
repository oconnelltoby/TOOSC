//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

extension OSCMessage: Equatable {
    public static func == (lhs: OSCMessage, rhs: OSCMessage) -> Bool {
        lhs.oscData == rhs.oscData
    }
}
