//
//  SpecifiedInformationType.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 11.11.2020.
//

import Foundation

extension BankingSystem.Bank.Client {
    
    /// Type for setting limit.
    enum SpecifiedInformationType {
        
        /// Name info filled.
        case name
        
        /// Address info filled.
        case address
        
        /// Passport info filled.
        case passport
    }
}
