//
//  INIDecoder.swift
//  INIDecoder
//
//  Created by Даниил Храповицкий on 25.09.2020.
//

import Foundation

final class INIDecoder {
    private var data: [String: [String: String]] = [:]
    
    private enum SectionType {
        case title(String)
        case properties(String, String)
    }
    
    private enum DataType {
        case title
        case property
        case value
    }
    
    public init(text: String) throws {
        let splittedText = text.components(separatedBy: .newlines)
        var title: String? = nil
        
        for line in splittedText {
            if line != "" {
                if let section = try parse(line: line) {
                    switch section {
                    case .title(let newTitle):
                        title = newTitle
                        
                    case .properties(let property, let value):
                        if let checkedTitle = title {
                            if var sections = data[checkedTitle] {
                                sections[property] = value
                                data[checkedTitle] = sections
                            } else {
                                var sections: [String: String] = [:]
                                sections[property] = value
                                data[checkedTitle] = sections
                            }
                        } else {
                            throw Exception.invalidSyntax
                        }
                    }
                }
            }
        }
    }
    
    public convenience init(data: Data) throws {
        guard let text = String(bytes: data, encoding: .utf8) else { throw Exception.invalidData }
        try self.init(text: text)
    }
    
    public convenience init(path: String) throws {
        guard let index = path.lastIndex(of: "."), path[path.index(after: index)...] == "ini", let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { throw Exception.invalidFilename }
        try self.init(data: data)
    }
    
    private func parse(line: String) throws -> SectionType? {
        var cache = ""
        var property: String? = nil
        var state = DataType.property
        
        var stack = Stack<DataType>()
        
        for character in line {
            switch character {
            case "[":
                if state == .property {
                    cache = ""
                    stack.push(state)
                    state = .title
                }
            
            case "]":
                if state == .title {
                    guard let newState = stack.pop() else { throw Exception.invalidSyntax }
                    state = newState
                    return .title(cache)
                }
                
            case "=":
                if state == .property {
                    property = cache
                    cache = ""
                    state = .value
                }
                
            case ";":
                if state == .value {
                    if let checkedProperty = property {
                        return .properties(checkedProperty, cache)
                    }
                } else {
                    return nil
                }
                
            case " ":
                break
            
            default:
                cache.append(character)
            }
        }
        
        guard state == .value, let checkedProperty = property else { throw Exception.invalidSyntax }
        return .properties(checkedProperty, cache)
    }
    
    public func print() {
        Swift.print(data)
    }
    
    public func print(title: String) {
        Swift.print(data[title] ?? "Такой секции нету :(")
    }
    
    public func print(title: String, property: String) {
        guard let section = data[title] else {
            Swift.print("Такой секции нету :(")
            return
        }
        Swift.print(section[property] ?? "Такого поля нету :(")
    }
}
