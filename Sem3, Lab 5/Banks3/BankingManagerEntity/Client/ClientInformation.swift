//
//  ClientInformation.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 10.11.2020.
//

import Foundation

extension BankingSystem.Bank.Client {
    
    /// Type for setting client information
    enum ClientInformation {
        
        /// Set  the client's name and surname.
        case name(name: String, surname: String)
        
        /// Set the client address.
        case address(String)
        
        /// Set the client's passport.
        case passport(String)
    }
}
