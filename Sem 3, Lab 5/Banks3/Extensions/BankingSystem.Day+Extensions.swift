//
//  BankingSystem.Day+Extensions.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 14.11.2020.
//

import Foundation

extension BankingSystem.Day {
    
    /// Returns BankingSystem.Day as day in TimeInterval.
    var day: TimeInterval {
        get {
            return Double(self * 24 * 60 * 60)
        }
    }
}
