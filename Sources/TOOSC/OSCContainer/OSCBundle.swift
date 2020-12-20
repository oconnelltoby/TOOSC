//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

public struct OSCBundle: OSCContainer {

    enum ParsingError: Error {
        case cannotParseIdentifier(error: Error)
        case invalidIdentifier
        case timeTagError(error: Error)
        case cannotParseSize(error: Error)
        case incorrectSize
        case invalidContent(error: Error)
    }
    
    public enum Content {
        case bundle(OSCBundle)
        case message(OSCMessage)
        
        var oscData: Data {
            switch self {
            case let .bundle(bundle):
                return bundle.oscData
            case let .message(message):
                return message.oscData
            }
        }
    }
    
    static var indentifier: String = "#bundle"
    
    var timeTag: TimeTag
    var content: [Content]
    
    public init(timeTag: TimeTag, content: [Content]) {
        self.content = content
        self.timeTag = timeTag
    }
    
    public init?(
        oscData: Data,
        argumentBuilders: [Character: (_ oscData: Data, _ index: inout Int) throws -> OSCArgument]
    ) throws {
        var index = 0
        try self.init(oscData: oscData, index: &index, argumentBuilders: argumentBuilders)
    }

    public init(
        oscData: Data,
        index: inout Int,
        argumentBuilders: [Character: (_ oscData: Data, _ index: inout Int) throws -> OSCArgument]
    ) throws {
        let identifier: String
        do { identifier = try String(oscData: oscData, index: &index) }
        catch { throw ParsingError.cannotParseIdentifier(error: error) }
        
        guard identifier == Self.indentifier else {
            throw ParsingError.invalidIdentifier
        }

        do { timeTag = try TimeTag(oscData: oscData, index: &index) }
        catch { throw ParsingError.timeTagError(error: error) }

        let size: Int32
        do { size = try Int32(oscData: oscData, index: &index) }
        catch { throw ParsingError.cannotParseSize(error: error) }
        
        guard oscData[index ..< oscData.endIndex].count == size else {
            throw ParsingError.incorrectSize
        }
        
        let end = index + Int(size)
        content = []

        while index < end {
            do {
                if oscData[index ..< oscData.endIndex].starts(with: Data(OSCMessage.indentifier.utf8)) {
                    let message = try OSCMessage(oscData: oscData, index: &index, argumentBuilders: argumentBuilders)
                    content.append(.message(message))
                } else if oscData[index ..< oscData.endIndex].starts(with: Data(OSCBundle.indentifier.utf8)) {
                    let bundle = try OSCBundle(oscData: oscData, index: &index, argumentBuilders: argumentBuilders)
                    content.append(.bundle(bundle))
                }
            } catch {
                throw ParsingError.invalidContent(error: error)
            }
        }
    }
    
    public var oscData: Data {
        let contentData = content.reduce(into: Data()) {
            $0 += $1.oscData
        }
        let length = Int32(contentData.count).bigEndian
        let lengthData = withUnsafeBytes(of: length) { Data($0) }
        
        return Self.indentifier.oscData + timeTag.oscData + lengthData + contentData
    }
}
