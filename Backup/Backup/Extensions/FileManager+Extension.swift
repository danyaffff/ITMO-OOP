//
//  FileManager+Extension.swift
//  Backup
//
//  Created by Даниил Храповицкий on 01.11.2020.
//

import Foundation

extension FileManager {
    func directoryExists(atPath path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
