//
//  Date+Extensions.swift
//  Reports
//
//  Created by Даниил Храповицкий on 02.12.2020.
//

import Foundation

extension Date {
    
    /// Compares current date with given for equality.
    func compare(with date: Date) -> Bool {
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
    }
}
