//
//  FileModel.swift
//  Backup
//
//  Created by Даниил Храповицкий on 01.11.2020.
//

import Foundation

struct FileModel: Equatable {
    //MARK: Properties
    /// Returns the filename.
    let name: String
    
    /// Returns the size of the file in KBytes.
    let size: CGFloat
}
