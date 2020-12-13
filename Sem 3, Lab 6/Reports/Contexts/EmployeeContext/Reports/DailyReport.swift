//
//  DailyReport.swift
//  Reports
//
//  Created by Даниил Храповицкий on 01.12.2020.
//

import Foundation

extension ReportSystem.EmployeesContext {
    
    public final class DailyReport: Report, CustomStringConvertible {
        
        public typealias Task = ReportSystem.ProjectContext.Project.Stage.Task
        public typealias Change = ReportSystem.EmployeesContext.Employee.Change
        
        //MARK: - Properties
        /// Returns the added changes.
        private(set) public var changes = [Change]()
        
        public var description: String {
            var returned = [String]()
            
            for change in changes {
                returned.append("\(change.task) : \(change.action)")
            }
            
            return returned.joined(separator: "\n")
        }
        
        //MARK: - Methods
        /// Returns new daily report instance.
        public class func create(id: Int, title: String, message: String, date: Date, employee: Employee) -> DailyReport {
            return DailyReport(id: id, title: title, message: message, date: date, employee: employee, type: .day)
        }
        
        /// Synchronizes the changes.
        public func synchronize() {
            guard state == .open else { return }
            
            for change in employee.changes {
                if !changes.contains(where: { $0.id == change.id }) {
                    changes.append(change)
                }
            }
        }
    }
}
