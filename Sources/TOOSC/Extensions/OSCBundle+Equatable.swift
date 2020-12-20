//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

extension OSCBundle: Equatable {
    public static func == (lhs: OSCBundle, rhs: OSCBundle) -> Bool {
        lhs.oscData == rhs.oscData
    }
}
