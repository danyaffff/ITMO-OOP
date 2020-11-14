//
//  main.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 10.11.2020.
//

import Foundation

BankingSystem.standard.createBank().set(name: "Сбербанк", limit: 5000, terms: [
    .debit(percent: 5),
    .deposit(expirationDate: Date(timeIntervalSinceNow: 60 * 60 * 24), percent: BankingSystem.DepositPercent(before: .init(value: 50000, percent: 3), between: .init(percent: 3.5), after: .init(value: 100000, percent: 4))),
    .credit(limit: 6000, commission: 22)
])

let sberbank = BankingSystem.standard.banks[0]

sberbank.addClient()?.set(info: [.name(name: "Даниил", surname: "Храповицкий"), .address("ул. Жуковского 41"), .passport("4115 696573")])
sberbank.addClient()?.set(info: [.name(name: "Евгения", surname: "Легостаева❤️")])

let danya = BankingSystem.standard.banks[0].clients[0]
let eugénie = BankingSystem.standard.banks[0].clients[1]

danya.createDebitAccount()?.add(sum: 15000)
eugénie.createDepositAccount()?.add(sum: 3700)
eugénie.createCreditAccount()?.add(sum: 0)

print(BankingSystem.standard, terminator: "\n\n")

eugénie.credit?.transfer(to: danya.debit, sum: 3000)
eugénie.credit?.transfer(to: danya.debit, sum: 1000)

eugénie.deposit?.transfer(to: danya.debit, sum: 1000)

//print(sberbank, terminator: "\n\n")

//eugénie.removeDepositAccount()

print(sberbank, terminator: "\n\n")

BankingSystem.standard.moveInTime(to: Date(timeIntervalSinceNow: 60 * 60 * 24 * 30))

print(sberbank, terminator: "\n\n")

eugénie.deposit?.transfer(to: danya.debit, sum: 3000)

print(sberbank, terminator: "\n\n")

eugénie.removeCreditAccount()
