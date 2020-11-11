//
//  BankTerms.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 10.11.2020.
//

import Foundation

extension BankingSystem.Bank {
    
    /// Type for setting terms.
    enum BankTerms {
        
        /// Set debit terms.
        case debit(percent: BankingSystem.Percent)
        
        /// Set deposit terms.
        case deposit(expirationDate: Date, percent: BankingSystem.DepositPercent)
        
        /// Set credit terms.
        case credit(limit: BankingSystem.Sum, commission: BankingSystem.Percent)
    }
}
