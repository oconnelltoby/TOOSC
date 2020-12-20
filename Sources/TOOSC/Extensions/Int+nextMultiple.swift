//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

extension Int {
    func nextMultiple(of multiple: Int) -> Int {
        (self + multiple - 1) / multiple * multiple
    }
}
