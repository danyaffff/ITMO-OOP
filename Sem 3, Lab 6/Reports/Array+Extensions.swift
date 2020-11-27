//
//  Array+Extensions.swift
//  Reports
//
//  Created by Даниил Храповицкий on 28.11.2020.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
