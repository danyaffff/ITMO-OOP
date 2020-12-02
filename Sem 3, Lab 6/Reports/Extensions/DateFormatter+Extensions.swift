//
//  DateFormatter+Extensions.swift
//  Reports
//
//  Created by Даниил Храповицкий on 03.12.2020.
//

import Foundation

extension DateFormatter {
    
    /// Formats date to *dd.MM.yyyy* format.
    static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
