//
//  BankingSystem.Percent+Extenions.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 14.11.2020.
//

import Foundation

extension BankingSystem.Percent {
    
    //MARK: - Properties
    /// Returns a decimal of a day's percentage.
    var decimal: BankingSystem.Percent {
        get {
            return self / (100 * 365)
        }
    }
    
    //MARK: - Methods
    /// Сhecks if a rhs  belongs to the range 0 ... 100 and assigns it to the lhs.
    static func <= (lhs: inout BankingSystem.Percent?, rhs: BankingSystem.Percent) {
        guard 0 ... 100 ~= rhs else {
            print("Founded a percent less than 0 or more than 100.")
            return
        }
        lhs = rhs
    }
}
