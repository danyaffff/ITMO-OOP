//
//  Account.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 10.11.2020.
//

import Foundation

/// Protocol for account functions.
protocol AccountProtocol: CustomStringConvertible {
    
    /// Adds sum to account.
    func add(sum: BankingSystem.Sum)
    
    /// Transfres sum from one account to another.
    func transfer(to account: BankingSystem.Bank.Client.Account?, sum: BankingSystem.Sum)
    
    /// Withdraws sum from account.
    func withdraw(sum: BankingSystem.Sum)
    
    /// Updates info.
    func update(info: [BankingSystem.Bank.Client.SpecifiedInformationType])
}

extension BankingSystem.Bank.Client {
    
    /// Base account class that contains sum and money operation methods.
    class Account {
        
        //MARK: - Properties
        /// Returns the amount of money in the account.
        private(set) var sum: BankingSystem.Sum = 0
        
        /// Returns the specified information.
        private var info: [SpecifiedInformationType]
        
        /// Sets the limit on account.
        private var limit: BankingSystem.Sum
        
        /// Returns the sum from percents.
        private var addableSum: BankingSystem.Sum = 0
        
        //MARK: - Initialization
        init(info: [SpecifiedInformationType], limit: BankingSystem.Sum) {
            self.info = info
            self.limit = limit
        }
        
        //MARK: - Methods
        /// Adds sum to account.
        func addSum(sum: BankingSystem.Sum) {
            self.sum += sum
        }
        
        /// Transfres sum from one account to another.
        func transferSum(to account: BankingSystem.Bank.Client.Account?, transferable: BankingSystem.Sum, transfered: BankingSystem.Sum) {
            guard sum >= transferable else {
                print("Insufficient funds.\n")
                return
            }
            
            guard let account = account else {
                print("Recipient account not found.\n")
                return
            }
            
            guard transferable < limit || info.count >= 2 else {
                print("You cannot transfer more than the limit.\n")
                return
            }
            
            if Int.random(in: 0...9) != 0 {
                print("Transfer allowed.\n")
                sum -= transferable
                account.addSum(sum: transfered)
            } else {
                print("Transfer isn't allowed.\n")
            }
        }
        
        /// Withdraws sum from account.
        func withdrawSum(sum: BankingSystem.Sum) {
            guard self.sum >= sum else {
                print("Insufficient funds.\n")
                return
            }
            
            guard sum < limit || info.count >= 2 else {
                print("You cannot withdraw more than the limit.\n")
                return
            }
            
            self.sum -= sum
        }
        
        /// Updates info.
        func updateInfo(newInfo: [SpecifiedInformationType]) {
            for info in newInfo {
                if !self.info.contains(info) {
                    self.info.append(info)
                }
            }
        }
        
        /// Updates the sum witch will be added at the beginning of the next month.
        func updateAddableSum(sum: BankingSystem.Sum) {
            addableSum += sum
        }
        
        /// Adds percents to sum.
        func addAddableSumToSum() {
            sum += addableSum
            addableSum = 0
        }
    }
    
    /// Interest debit account.
    final class DebitAccount: Account, AccountProtocol {
        
        //MARK: - Properties
        /// Returns the debit percent.
        private(set) var percent: BankingSystem.Percent
        
        var description: String {
            return "Debit: \(sum)₽"
        }
        
        //MARK: - Initialization
        /// Initializes the debit percent.
        init(percent: BankingSystem.Percent, info: [SpecifiedInformationType], limit: BankingSystem.Sum) {
            self.percent = percent
            
            super.init(info: info, limit: limit)
        }
        
        //MARK: - Methods
        func add(sum: BankingSystem.Sum) {
            super.addSum(sum: sum)
        }

        func transfer(to account: BankingSystem.Bank.Client.Account?, sum: BankingSystem.Sum) {
            super.transferSum(to: account, transferable: sum, transfered: sum)
        }

        func withdraw(sum: BankingSystem.Sum) {
            super.withdrawSum(sum: sum)
        }
        
        func update(info: [SpecifiedInformationType]) {
            super.updateInfo(newInfo: info)
        }
        
        /// Moves time forward.
        func moveInTime(by days: BankingSystem.Day) {
            for day in 0 ..< days {
                super.updateAddableSum(sum: BankingSystem.Sum(floor(BankingSystem.Percent(super.sum) * percent / 100)))
                
                let monthday = Calendar.current.ordinality(of: .day, in: .month, for: Date(timeIntervalSinceNow: 60 * 60 * 24 * TimeInterval(day)))
                
                if monthday == 1 {
                    super.addAddableSumToSum()
                }
            }
        }
    }
    
    ///The deposit from which money cannot be transferred until the expiration date.
    final class DepositAccount: Account, AccountProtocol {
        
        //MARK: - Properties
        /// Returns the date when money can be transferred and withdrawn.
        private(set) var expirationDate: Date
        
        /// Returns the deposit percent.
        private(set) var percent: BankingSystem.DepositPercent
        
        /// Returns time shift by days.
        private var timeShift: BankingSystem.Day = 0
        
        var description: String {
            return "Deposit \(sum)₽"
        }
        
        //MARK: - Initialization
        init(expirationDate: Date, percent: BankingSystem.DepositPercent, info: [SpecifiedInformationType], limit: BankingSystem.Sum) {
            self.expirationDate = expirationDate
            self.percent = percent
            
            super.init(info: info, limit: limit)
        }
        
        //MARK: - Methods
        func add(sum: BankingSystem.Sum) {
            super.addSum(sum: sum)
        }

        func transfer(to account: BankingSystem.Bank.Client.Account?, sum: BankingSystem.Sum) {
            guard Date(timeIntervalSinceNow: 60 * 60 * 24 * TimeInterval(timeShift)) >= expirationDate else {
                print("The expiration date has not yet expired.\n")
                return
            }
            
            super.transferSum(to: account, transferable: sum, transfered: sum)
        }

        func withdraw(sum: BankingSystem.Sum) {
            guard Date(timeIntervalSinceNow: 60 * 60 * 24 * TimeInterval(timeShift)) >= expirationDate else {
                print("The expiration date has not yet expired.\n")
                return
            }
            
            super.withdrawSum(sum: sum)
        }
        
        func update(info: [SpecifiedInformationType]) {
            super.updateInfo(newInfo: info)
        }
        
        /// Moves time forward.
        func moveInTime(by days: BankingSystem.Day) {
            timeShift += days
            
            for day in 0 ..< days {
                if super.sum < percent.before.value {
                    super.updateAddableSum(sum: BankingSystem.Sum(floor(BankingSystem.Percent(super.sum) * percent.before.percent / 100)))
                } else if super.sum > percent.after.value {
                    super.updateAddableSum(sum: BankingSystem.Sum(floor(BankingSystem.Percent(super.sum) * percent.after.percent / 100)))
                } else {
                    super.updateAddableSum(sum: BankingSystem.Sum(floor(BankingSystem.Percent(super.sum) * percent.between / 100)))
                }
                
                let monthday = Calendar.current.ordinality(of: .day, in: .month, for: Date(timeIntervalSinceNow: 60 * 60 * 24 * TimeInterval(day)))
                
                if monthday == 1 {
                    super.addAddableSumToSum()
                }
            }
        }
    }
    
    /// Credit account with a limit, after which a commission is charged.
    final class CreditAccount: Account, AccountProtocol {
        
        //MARK: - Properties
        /// Returns the credit limit.
        private(set) var limit: BankingSystem.Sum
        
        /// Returns the comission.
        private(set) var commission: BankingSystem.Percent
        
        var description: String {
            return "Credit \(Int(sum) - Int(limit))₽"
        }
        
        //MARK: - Initialization
        init(creditLimit: BankingSystem.Sum, commission: BankingSystem.Percent, info: [SpecifiedInformationType], limit: BankingSystem.Sum) {
            self.limit = creditLimit
            self.commission = commission
            
            super.init(info: info, limit: limit)
            
            super.addSum(sum: creditLimit)
        }
        
        //MARK: - Methods
        func add(sum: BankingSystem.Sum) {
            super.addSum(sum: sum)
        }

        func transfer(to account: BankingSystem.Bank.Client.Account?, sum: BankingSystem.Sum) {
            super.transferSum(to: account, transferable: super.sum < self.limit ? sum + BankingSystem.Sum(ceil(BankingSystem.Percent(sum) * commission / 100)) : sum, transfered: sum)
        }

        func withdraw(sum: BankingSystem.Sum) {
            super.withdrawSum(sum: super.sum < self.limit ? sum + BankingSystem.Sum(ceil(BankingSystem.Percent(sum) * commission / 100)) : sum)
        }
        
        func update(info: [SpecifiedInformationType]) {
            super.updateInfo(newInfo: info)
        }
    }
}
