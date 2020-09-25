//
//  stack.swift
//  INIDecoder
//
//  Created by Даниил Храповицкий on 25.09.2020.
//

import Foundation

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
