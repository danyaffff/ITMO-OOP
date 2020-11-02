//
//  main.swift
//  Backup
//
//  Created by Даниил Храповицкий on 01.11.2020.
//

import Foundation

Backup.shared.add(.file(withName: "1.txt"))
Backup.shared.add(.folder(withName: "Folder"))

Backup.shared.createRestorePoint(ofType: .full)

Backup.shared.add(.file(withName: "1.txt"))
Backup.shared.add(.folder(withName: "Folder"))

Backup.shared.createRestorePoint(ofType: .full)

Backup.shared.add(.file(withName: "1.txt"))
Backup.shared.add(.folder(withName: "Folder"))

Backup.shared.createRestorePoint(ofType: .full)

Backup.shared.add(.file(withName: "1.txt"))
Backup.shared.add(.folder(withName: "Folder"))

Backup.shared.createRestorePoint(ofType: .full)

Backup.shared.add(.file(withName: "1.txt"))
Backup.shared.add(.folder(withName: "Folder"))

Backup.shared.createRestorePoint(ofType: .full)

Backup.shared.add(.file(withName: "1.txt"))
Backup.shared.add(.folder(withName: "Folder"))

Backup.shared.createRestorePoint(ofType: .full)

Backup.shared.add(.file(withName: "1.txt"))
Backup.shared.add(.folder(withName: "Folder"))

Backup.shared.createRestorePoint(ofType: .full)

//Backup.shared.add(.file(withName: "1.txt"))
//Backup.shared.add(.folder(withName: "Folder"))
//
//Backup.shared.createRestorePoint(ofType: .increment)

print(Backup.shared)

Backup.shared.setFilterForRemoving(condition: .size(size: 12))
//Backup.shared.setFilterForRemoving(condition: .quantity(amount: 1))
//Backup.shared.setFilterForRemoving(condition: .one([.quantity(amount: 3), .size(size: 40)]))
//Backup.shared.setFilterForRemoving(condition: .some([.quantity(amount: 3), .size(size: 40)]))
Backup.shared.update()

print(Backup.shared)
