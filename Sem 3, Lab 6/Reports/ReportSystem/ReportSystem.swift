//
//  ReportSystem.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

/** An interface to the project management class, where you manage the creation of the project.
 
 The ReportingSystem class provides a programming interface for interacting with the reporting system. The reporting system allows you to automate the creation of reports for a specific multi-step project. For example, you can create a worker, add several tasks to him, and then manage him by performing tasks and creating reports on the work done.
 */
public final class ReportSystem: CustomStringConvertible {
    
    //MARK: - Properties
    /// Returns the singleton of Report System.
    public static let `default` = ReportSystem()
    
    /// Returns emplyees context.
    public let employeesContext = EmployeesContext()
    
    /// Returns project context.
    public let projectContext = ProjectContext()
    
    /// Returns current date.
    private(set) public var date = Date()
    
    public var description: String {
        var returned = [String](arrayLiteral: "Employees:")
        
        returned.append("\(employeesContext)\n\n")
        returned.append("Project:")
        returned.append("\(projectContext)")
        
        return returned.joined(separator: "\n")
    }
    
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
