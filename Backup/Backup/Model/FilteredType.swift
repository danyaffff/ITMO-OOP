//
//  FilteredType.swift
//  Backup
//
//  Created by Даниил Храповицкий on 02.11.2020.
//

import Foundation

/// The type of removed algoriths.
enum FilteredType {
    
    //MARK: Cases
    /// No condition for removing.
    case none
        
    /// Limits the number of restore points.
    case quantity(amount: Int)
    
    /// Removes restore points older than a cretain date.
    case date(date: Date)
    
    /// Limits the entire size of the Backup.
    case size(size: CGFloat)
    
    /// Removes restore points that don't match at least one condition.
    case one([FilteredType])
    
    /// Removes restore points that don't match all conditions.
    case some([FilteredType])
}
