//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

extension TimeTag: Equatable {
    public static func == (lhs: TimeTag, rhs: TimeTag) -> Bool {
        lhs.ntpSeconds == rhs.ntpSeconds
    }
}
