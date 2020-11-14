//
//  Client.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 10.11.2020.
//

import Foundation

extension BankingSystem.Bank {
    
    /// The class that describes the client.
    final class Client: CustomStringConvertible {
        
        //MARK: - Properties
        /// Returns the name of client.
        private(set) var name: String
        
        /// Returns the surname of client.
        private(set) var surname: String
        
        /// Return the address of client.
        private(set) var address: String? = nil
        
        /// Returns the passport of client.
        private(set) var passport: String? = nil
        
        /// Returns the debit account of client.
        private(set) var debit: DebitAccount? = nil
        
        /// Returns the deposit account of client.
        private(set) var deposit: DepositAccount? = nil
        
        /// Returns the credit account of client.
        private(set) var credit: CreditAccount? = nil
        
        /// Returns the terms of bank.
        private let terms: (debit: BankingSystem.Percent?, deposit: (expirationDate: Date?, percent: BankingSystem.DepositPercent?), credit: (limit: BankingSystem.Sum?, commission: BankingSystem.Percent?))
        
        /// Returns transfer and withdraw limit.
        private var limit: BankingSystem.Sum
        
        var description: String {
            var returned: [String] = []
            var returnedInfo: [String] = []
            
            returnedInfo.append(name + " " + surname)
            
            if let address = address {
                returnedInfo.append(address)
            }
            
            if let passport = passport {
                returnedInfo.append(passport)
            }
            
            returned.append(returnedInfo.joined(separator: ", "))
            
            if let debit = debit {
                returned.append("-- \(debit.description)")
            }
            
            if let deposit = deposit {
                returned.append("-- \(deposit.description)")
            }
            
            if let credit = credit {
                returned.append("-- \(credit.description)")
            }
            
            return returned.joined(separator: "\n")
        }
        
        //MARK: - Initialization
        /// Initilizes the standard values.
        init(name: String, surname: String, terms: (debit: BankingSystem.Percent?, deposit: (expirationDate: Date?, percent: BankingSystem.DepositPercent?), credit: (limit: BankingSystem.Sum?, commission: BankingSystem.Percent?)), limit: BankingSystem.Sum) {
            self.name = name
            self.surname = surname
            self.terms = terms
            self.limit = limit
        }
        
        //MARK: - Methods
        /// Sets client information.
        func set(info: [ClientInformation]) {
            guard self.name ~= "NAME[0-9]+" else {
                print("You already set name and surname of client. If you want to update address and passport information, please use update(info:) function.\n")
                return
            }
            
            for field in info {
                switch field {
                case .name(let name, let surname):
                    self.name = name
                    self.surname = surname
                case .address(let address):
                    self.address = address
                case .passport(let passport):
                    self.passport = passport
                }
            }
        }
        
        /// Updates client information.
        func update(info: [ClientInformation]) {
            guard !(self.name ~= "NAME[0-9]+") else {
                print("First set name and surname using set(info:) function.\n")
                return
            }
            
            for field in info {
                switch field {
                case .address(let address):
                    self.address = address
                case .passport(let passport):
                    self.passport = passport
                default:
                    break
                }
            }
            
            var info: [SpecifiedInformationType] = [.name]
            
            if let _ = address {
                info.append(.address)
            }
            
            if let _ = passport {
                info.append(.passport)
            }
            
            if let debit = debit {
                debit.update(info: info)
            }
            
            if let deposit = deposit {
                deposit.update(info: info)
            }
            
            if let credit = credit {
                credit.update(info: info)
            }
        }
        
        /// Creates the debit account.
        func createDebitAccount() -> DebitAccount? {
            guard !(self.name ~= "NAME[0-9]+") else {
                print("First set name and surname using set(info:) function.\n")
                return nil
            }
            
            guard debit == nil else {
                printCreateError(for: .debit)
                return nil
            }
            
            guard let debitTerm = terms.debit else {
                print("The bank does not issue an account of this type.\n")
                return nil
            }
            
            var info: [SpecifiedInformationType] = [.name]
            
            if let _ = address {
                info.append(.address)
            }
            
            if let _ = passport {
                info.append(.passport)
            }
            
            debit = DebitAccount(percent: debitTerm, info: info, limit: limit)
            
            return debit
        }
        
        /// Creates the deposit account.
        func createDepositAccount() -> DepositAccount? {
            guard !(self.name ~= "NAME[0-9]+") else {
                print("First set name and surname using set(info:) function.\n")
                return nil
            }
            
            guard deposit == nil else {
                printCreateError(for: .deposit)
                return nil
            }
            
            guard let depositExpirationDate = terms.deposit.expirationDate, let depositPercent = terms.deposit.percent else {
                print("The bank does not issue an account of this type.\n")
                return nil
            }
            
            var info: [SpecifiedInformationType] = [.name]
            
            if let _ = address {
                info.append(.address)
            }
            
            if let _ = passport {
                info.append(.passport)
            }
            
            deposit = DepositAccount(expirationDate: depositExpirationDate, percent: depositPercent, info: info, limit: limit)
            
            return deposit
        }
        
        /// Creates the credit account.
        func createCreditAccount() -> CreditAccount? {
            guard !(self.name ~= "NAME[0-9]+") else {
                print("First set name and surname using set(info:) function.\n")
                return nil
            }
            
            guard credit == nil else {
                printCreateError(for: .credit)
                return nil
            }
            
            guard let creditLimit = terms.credit.limit, let creditCommission = terms.credit.commission else {
                print("The bank does not issue an account of this type.\n")
                return nil
            }
            
            var info: [SpecifiedInformationType] = [.name]
            
            if let _ = address {
                info.append(.address)
            }
            
            if let _ = passport {
                info.append(.passport)
            }
            
            credit = CreditAccount(creditLimit: creditLimit, commission: creditCommission, info: info, limit: limit)
            
            return credit
        }
        
        /// Prints an error.
        private func printCreateError(for type: AccountType) {
            var account = ""
            
            switch type {
            case .debit:
                account = "debit"
            case .deposit:
                account = "deposit"
            case .credit:
                account = "credit"
            }
            
            print("You have already created a \(account) account. To update an account use access to [\(account)] element. To remove an account use remove\(account.capitalized)Account().\n")
        }
        
        /// Removes the debit account.
        func removeDebitAccount() {
            guard let _ = debit else {
                printRemoveError(for: .debit)
                return
            }
            
            debit = nil
            print("Removed successfuly.\n")
        }
        
        /// Removes the deposit account.
        func removeDepositAccount() {
            guard let _ = deposit else {
                printRemoveError(for: .deposit)
                return
            }
            
            deposit = nil
            print("Removed successfuly.\n")
        }
        
        /// Removes the credit account.
        func removeCreditAccount() {
            guard let credit = credit else {
                printRemoveError(for: .credit)
                return
            }
            
            guard Int(credit.sum) - Int(limit) >= 0 else {
                print("It is impossible to close a credit account if the debt is not paid off.")
                return
            }
            
            self.credit = nil
            print("Removed successfuly.\n")
        }
        
        /// Prints an error.
        private func printRemoveError(for type: AccountType) {
            var account = ""
            
            switch type {
            case .debit:
                account = "debit"
            case .deposit:
                account = "deposit"
            case .credit:
                account = "credit"
            }
            
            print("No \(account) account found. To create a new one, use create\(account.capitalized)Account().\n")
        }
        
        /// Moves time forward.
        func moveInTime(by days: BankingSystem.Day) {
            if let debit = debit {
                debit.moveInTime(by: days)
            }
            
            if let deposit = deposit {
                deposit.moveInTime(by: days)
            }
        }
    }
}
