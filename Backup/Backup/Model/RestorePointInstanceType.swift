//
//  RestorePointInstanceType.swift
//  Backup
//
//  Created by Даниил Храповицкий on 01.11.2020.
//

import Foundation

/// The type of restore point.
enum RestorePointInstanceType {
    /// Contains full information about files.
    case full
    
    /// Contains difference of changes.
    case increment
}
