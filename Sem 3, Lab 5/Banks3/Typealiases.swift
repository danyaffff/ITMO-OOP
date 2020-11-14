//
//  Typealiases.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 14.11.2020.
//

import Foundation

extension BankingSystem {
    
    /// Percent, CGFloat from 0 to 100
    typealias Percent = CGFloat
    
    /// Sum, UInt
    typealias Sum = UInt
    
    /// Day, UInt
    typealias Day = UInt
}

extension BankingSystem {
    
    /// Сontains percents depending on the sum.
    struct DepositPercent {
        
        //MARK: - Types
        /// Declares percent before a certein sum.
        struct Before {
            let value: Sum
            let percent: Percent
        }
        
        /// Declares percent between before and after sums.
        struct Between {
            let percent: Percent
        }
        
        /// Declares percent after a certain sum.
        struct After {
            let value: Sum
            let percent: Percent
        }
        
        //MARK: - Properties
        /// Returns before declaration.
        var before: Before
        
        /// Returns between declaration.
        var between: Between
        
        /// Returns after declaration.
        var after: After
        
        //MARK: - Methods
        /// Сhecks if a rhs belongs to the range 0 ... 100 and assigns it to the lhs.
        static func <= (lhs: inout BankingSystem.DepositPercent?, rhs: BankingSystem.DepositPercent) {
            guard 0 ... 100 ~= rhs.before.percent && 0 ... 100 ~= rhs.between.percent && 0 ... 100 ~= rhs.after.percent else {
                print("Founded a percent less than 0 or more than 100.")
                return
            }
            lhs = rhs
        }
    }
}
