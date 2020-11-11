//
//  String+Extensions.swift
//  Banks3
//
//  Created by Даниил Храповицкий on 10.11.2020.
//

import Foundation

extension String {
    
    /// Pattern match.
    static func ~= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
