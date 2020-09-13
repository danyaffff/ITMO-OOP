//
//  main.swift
//  INIDecoder
//
//  Created by Даниил Храповицкий on 12.09.2020.
//

import Foundation

enum Exception: Error {
    case invalidSyntax
    case invalidFilename
    case invalidData
    case test1
    case test2
}

struct Stack<T> {
    private var data: [T] = []
    
    mutating public func push(_ element: T) {
        data.append(element)
    }
    
    mutating public func pop() -> T? {
        return data.popLast()
    }
    
    public func peek() -> T? {
        return data.last
    }
}

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

print("Введите название файла >> ", terminator: "")
let inputFilename = readLine(strippingNewline: true)!

do {
    let decoder = try INIDecoder(path: inputFilename)
    
    var operation: String = ""
    
    print("""
    Введите одну из операций:
    p - вывод всех секций
    p <секция> - вывод всех полей секции
    p <секция> <поле> - вывод значения поля
    q - выход
    """)
    
    while operation != "q" {
        print("Операция >> ", terminator: "")
        operation = readLine()!
        
        let command = operation.components(separatedBy: " ")
        
        switch command[0] {
        case "p":
            if let title = command[safe: 1] {
                if let property = command[safe: 2] {
                    if let _ = command[safe: 3] {
                        print("Введен лишний аргумент, попытка обработать запрос...")
                    }
                    
                    decoder.print(title: title, property: property)
                } else {
                    decoder.print(title: title)
                }
            } else {
                decoder.print()
            }
            
        case "q":
            break
        
        default:
            print("Операция не распознана, попробуй еще раз :(")
        }
    }
} catch Exception.invalidFilename {
    print("Введено неверное имя файла!")
} catch Exception.invalidData {
    print("Невозможно прочитать данные!")
} catch Exception.invalidSyntax {
    print("INI-данные неверны!")
} catch {
    print("Произошла неизвестная ошибка!")
}

extension Array {
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
