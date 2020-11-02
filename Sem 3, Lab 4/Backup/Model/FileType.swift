//
//  FileType.swift
//  Backup
//
//  Created by Даниил Храповицкий on 01.11.2020.
//

import Foundation

/// The type of addable element.
enum FileType {
    
    //MARK: Cases
    /// Add file.
    case file(withName: String)
    
    /// Add folder.
    case folder(withName: String)
}
