//
//  ReportSystem.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

public final class ReportSystem {
    
    //MARK: - Properties
    /// Returns the singleton of Report System.
    public static let `default` = ReportSystem()
    
    /// Returns emplyees context.
    public let employeesContext = EmployeesContext()
    
    /// Returns project context.
    public let projectContext = ProjectContext()
    
    /// Returns current date.
    private(set) public var date = Date()
    
    //MARK: - Initializer
    /// Private initializator.
    private init() {}
    
    //MARK: - Methods
    /// Moves current date to Tomorrow.
    public func move() {
        closeReports()
        
        date += TimeInterval(60 * 60 * 24)
    }
    
    /// Closes reports for editing.
    private func closeReports() {
        for employee in employeesContext.employees {
            employee.report?.close()
        }
    }
}
