import Foundation

public protocol OSCArgument {
    static var typeTag: Character { get }
    init?(oscData: Data, index: inout Int)
    var oscData: Data { get }
}
