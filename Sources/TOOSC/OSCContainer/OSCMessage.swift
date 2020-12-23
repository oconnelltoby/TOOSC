//
// Copyright © 2020 Toby O'Connell. https://github.com/oconnelltoby
//

import Foundation

public struct OSCMessage: OSCContainer {
    public enum ParsingError: Error {
        case invalidIdentifier
        case cannotParseTypeTags(error: Error)
        case invalidTypeTagIdentifier
        case invalidAddress(error: Error)
        case typeTagError(error: Error)
        case argumentBuildingError(error: Error)
    }
    
    static var indentifier: String = "/"
    
    public var address: String
    public var arguments: [OSCArgument]
    
    public init(address: String, arguments: [OSCArgument]) {
        self.address = address
        self.arguments = arguments
    }
    
    public var oscData: Data {
        var typeTags = ","
        var argumentData = Data()

        arguments.forEach { argument in
            typeTags.append(type(of: argument).typeTag)
            argumentData.append(argument.oscData)
        }

        return address.oscData + typeTags.oscData + argumentData
    }

    public init(
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
        let oscData = oscData[index ..< oscData.count]
        guard oscData.starts(with: Self.indentifier.utf8) else {
            throw ParsingError.invalidIdentifier
        }

        do { address = try String(oscData: oscData, index: &index) }
        catch { throw ParsingError.invalidAddress(error: error) }

        let typeTags: String
        do {
            typeTags = try String(oscData: oscData, index: &index)
        } catch {
            throw ParsingError.cannotParseTypeTags(error: error)
        }
        
        guard typeTags.starts(with: ",") else {
            throw ParsingError.invalidTypeTagIdentifier
        }
        
        do {
            arguments = try typeTags.dropFirst().compactMap { typeTag in
                try argumentBuilders[typeTag]?(oscData, &index)
            }
        } catch {
            throw ParsingError.argumentBuildingError(error: error)
        }
    }
}
