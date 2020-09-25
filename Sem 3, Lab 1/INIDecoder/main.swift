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
