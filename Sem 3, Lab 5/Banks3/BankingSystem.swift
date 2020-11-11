//
//  BankingSystem.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 10.11.2020.
//

import Foundation

/**
The centralized point of control and coordination of Banking System.
The BankingSystem class provides a programmatic interface for interacting with the bank system. The bank system allows an app to create a banks, clients and accounts and
 allows you to perform transactions on accounts.
*/
final class BankingSystem: CustomStringConvertible {
    
    /// Percent, CGFloat from 0 to 100
    typealias Percent = CGFloat
    
    /// Sum, UInt
    typealias Sum = UInt
    
    /// Deposit percent, (before: (value: Sum, percent: Percent), between: Percent, after: (value: Sum, percent: Percent))
    typealias DepositPercent = (before: (value: Sum, percent: Percent), between: Percent, after: (value: Sum, percent: Percent))
    
    /// Day, UInt
    typealias Day = UInt
    
    //MARK: - Properties
    /// Returns the shared system object.
    static let standard = BankingSystem()
    
    /// Returns the added banks.
    private(set) var banks: [Bank] = []
    
    var description: String {
        var returned: [String] = []
        
        for bank in banks {
            returned.append(bank.description)
        }
        
        return returned.joined(separator: "\n")
    }
    
    //MARK: - Initialization
    /// Banking system's private initializer.
    private init() {}
    
    //MARK: - Methods
    /// Creates new bank.
    func createBank() -> Bank {
        banks.append(Bank(name: "Bank \(banks.count)"))
        
        return banks.last!
    }
    
    /// Removes bank with its clients.
    func removeBank(_ bank: Bank) {
        guard let index = banks.firstIndex(where: { $0.name == bank.name }) else { return }
        
        banks.remove(at: index)
    }
    
    /// Moves current date forward.
    func moveInTime(to date: Date) {
        let calendar = Calendar.current
        
        let from = calendar.startOfDay(for: Date())
        let to = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: from, to: to)
        
        guard let days = components.day, days > 0 else {
            print("Something went wrong and date is wrong or the difference is negative.")
            return
        }
        
        for bank in banks {
            bank.moveInTime(by: UInt(days))
        }
    }
}
