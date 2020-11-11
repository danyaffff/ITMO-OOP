//
//  Bank.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 10.11.2020.
//

import Foundation

extension BankingSystem {
    
    final class Bank: CustomStringConvertible {
        
        //MARK: - Properties
        /// Formats date to "dd.MM.yyyy".
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter
        }()
        
        /// Returns the name of bank.
        private(set) var name: String
        
        /// Returns the terms of bank.
        private(set) var terms: (debit: Percent?, deposit: (expirationDate: Date?, percent: DepositPercent?), credit: (limit: Sum?, commission: Percent?))
        
        /// Returns restrictions on withdraws and transfers.
        private(set) var limit: BankingSystem.Sum = 0
        
        /// Return the clients of bank.
        private(set) var clients: [Client] = []
        
        private var timeShift: Day = 0
        
        var description: String {
            var returned: [String] = [name + ": "]
            var returnedTerms: [String] = []
            
            if let debitPercent = terms.debit {
                returnedTerms.append("· Debit: \(debitPercent)%")
            }
            
            if let depositExpirationDate = terms.deposit.expirationDate, let depositPercent = terms.deposit.percent {
                
                let percent = "<\(depositPercent.before.value)Р — \(depositPercent.before.percent)%, \(depositPercent.before.value)—\(depositPercent.after.value)Р — \(depositPercent.between)%, >\(depositPercent.after.value)Р — \(depositPercent.after.percent)%"
                
                returnedTerms.append("· Deposit: \(formatter.string(from: depositExpirationDate)), \(percent)")
            }
            
            if let creditLimit = terms.credit.limit, let creditCommission = terms.credit.commission {
                returnedTerms.append("· Credit: \(creditLimit)₽, \(creditCommission)%")
            }
            
            returned.append(returnedTerms.joined(separator: ";\n"))
            
            
            for client in clients {
                returned.append("- " + client.description)
            }
            
            return returned.joined(separator: "\n")
        }
        
        //MARK: - Initialization
        /// Initializes the standard values.
        init(name: String) {
            self.name = name
        }
        
        //MARK: - Methods
        /// Sets name and terms of bank.
        func set(name: String, limit: BankingSystem.Sum, terms: [BankTerms]) {
            guard self.name ~= "Bank [0-9]+" else {
                print("You already set bank's name. If you want update terms, please use update(terms:) function.\n")
                return
            }
            guard !BankingSystem.standard.banks.contains(where: { $0.name == name }) else {
                print("Bank with the same name is already exists.\n")
                return
            }
            
            self.name = name
            
            self.limit = limit
            
            for term in terms {
                switch term {
                case .debit(let percent):
                    self.terms.debit = percent
                case .deposit(let expirationDate, let percent):
                    self.terms.deposit.expirationDate = expirationDate
                    self.terms.deposit.percent = percent
                case .credit(let limit, let commission):
                    self.terms.credit.limit = limit
                    self.terms.credit.commission = commission
                }
            }
        }
        
        /// Updates terms of bank.
        func update(terms: [BankTerms]) {
            guard !(self.name ~= "Bank [0-9]+") else {
                print("First set name and terms using set(name:terms:) function.\n")
                return
            }
            
            for term in terms {
                switch term {
                case .debit(let percent):
                    self.terms.debit = percent
                case .deposit(let expirationDate, let percent):
                    self.terms.deposit.expirationDate = expirationDate
                    self.terms.deposit.percent = percent
                case .credit(let limit, let commission):
                    self.terms.credit.limit = limit
                    self.terms.credit.commission = commission
                }
            }
        }
        
        /// Adds client to bank.
        func addClient() -> Client? {
            guard !(self.name ~= "Bank [0-9]+") else {
                print("First set name and terms using set(name:terms:) function.\n")
                return nil
            }
            
            clients.append(Client(name: "NAME\(clients.count)", surname: "SURNAME\(clients.count)", terms: terms, limit: limit))
            
            return clients[clients.count - 1]
        }
        
        /// Moves time forward.
        func moveInTime(by day: Day) {
            for client in clients {
                client.moveInTime(by: day)
            }
        }
    }
}
