//
//  RestorePointModel.swift
//  Backup
//
//  Created by Даниил Храповицкий on 01.11.2020.
//

import Foundation

struct RestorePointModel: Equatable, CustomStringConvertible {
    
    //MARK: Properties
    /// Returns the files in restore point.
    let files: [FileModel]
    
    /// Returns the size of restore point.
    let size: CGFloat
    
    /// Returns the date of restore point.
    let date: Date
    
    /// Returns type of restore point.
    let type: RestorePointInstanceType
    
    //MARK: - Protocols
    var description: String {
        var returned: [String] = []
        
        for file in files {
            returned.append("\(file.name): \((file.size * 100).rounded() / 100) KB")
        }
        
        return returned.joined(separator: "\n")
    }
    
    static func == (lhs: RestorePointModel, rhs: RestorePointModel) -> Bool {
        return lhs.files == rhs.files
    }
}
