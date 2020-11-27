//
//  EmpolyeeContext.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem {
    
    final class EmployeesContext: CustomStringConvertible {
        
        /// Returns the added employees.
        private(set) var employees = [Employee]()
        
        /// Returns the team leader.
        private(set) var teamLeader: Employee? = nil
        
        var description: String {
            guard let index = employees.firstIndex(where: { $0.head == nil }) else { return "" }
            return "\(employees[index])"
        }
        
        /// Creates new employee.
        func createEmployee(name: String, head: Employee? = nil) -> Employee? {
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
    }
}
