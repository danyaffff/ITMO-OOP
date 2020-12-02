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
        
        /// Change type.
        public enum Change: Equatable {
            
            /// Opened the task.
            case open(date: Date, employee: Employee)
            
            /// Activated the task.
            case activate(date: Date, employee: Employee)
            
            /// Resolved the task.
            case resolve(date: Date, employee: Employee)
            
            /// Added the task.
            case add(date: Date, employee: Employee)
            
            /// Changed the message.
            case message(date: Date, employee: Employee)
            
            /// Delegeted employee.
            case employee(date: Date, employee: Employee)
            
            /// Returns the date of change.
            func getDate() -> Date {
                switch self {
                case .open(let date, _):
                    return date
                case .activate(let date, _):
                    return date
                case .resolve(let date, _):
                    return date
                case .add(let date, _):
                    return date
                case .message(let date, _):
                    return date
                case .employee(let date, _):
                    return date
                }
            }
            
            /// Returns the employee of change.
            func getEmployee() -> Employee {
                switch self {
                case .open(_, let employee):
                    return employee
                case .activate(_, let employee):
                    return employee
                case .resolve(_, let employee):
                    return employee
                case .add(_, let employee):
                    return employee
                case .message(_, let employee):
                    return employee
                case .employee(_, let employee):
                    return employee
                }
            }
        }
    }
}
