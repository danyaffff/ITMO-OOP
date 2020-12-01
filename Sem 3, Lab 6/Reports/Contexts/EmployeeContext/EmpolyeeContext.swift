//
//  EmpolyeeContext.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem {
    
    public final class EmployeesContext: CustomStringConvertible {
        
        /// Returns the added employees.
        private(set) public var employees = [Employee]()
        
        /// Returns the team leader.
        private(set) public var teamLeader: Employee? = nil
        
        public var description: String {
            guard let index = employees.firstIndex(where: { $0.head == nil }) else { return "" }
            return "\(employees[index])"
        }
        
        /// Creates new employee.
        public func createEmployee(name: String, head: Employee? = nil) -> Employee? {
            switch employees.count {
            case 0:
                guard head == nil else { return nil }
                employees.append(Employee.employee(id: employees.count, name: name))
                teamLeader = employees.last
                
            default:
                guard let head = head else { return nil }
                employees.append(Employee.employee(id: employees.count, name: name, head: head))
            }
            
            return employees.last
        }
        
        //MARK: - Structures
        public enum ReportType {
            
            /// Create a day report.
            case day
            
            /// Create a stage report.
            case stage
        }
    }
}
