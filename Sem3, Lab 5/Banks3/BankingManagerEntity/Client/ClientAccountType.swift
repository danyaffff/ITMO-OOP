//
//  ClientAccountType.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 10.11.2020.
//

import Foundation

extension BankingSystem.Bank.Client {
    
    /// Type for creating account.
    enum AccountType {
        
        /// Create a debit account.
        case debit
        
        /// Create a deposit account.
        case deposit
        
        /// Create a credit account.
        case credit
    }
}
