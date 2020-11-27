//
//  Employee.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.EmployeesContext {
    
    final class Employee: Equatable, CustomStringConvertible {
        
        typealias Task = ReportSystem.ProjectContext.Project.Stage.Task
        typealias Change = Task.Change
        
        //MARK: - Properties
        /// Returns the id of employee.
        let id: Int
        
        /// Returns the name of employee.
        let name: String
        
        /// Returns the head of employee.
        private(set) var head: Employee?
        
        /// Returns the subordinates of employee.
        private(set) var subordinates = [Employee]()
        
        /// Returns tasks that delegated to current employee.
        private(set) var delegatedTasks = [Task]()
        
        /// Returns distance from teamlead.
        private(set) var distance: Int
        
        /// Returns the unsynchronized changes.
        private(set) var changes = [(id: Int, task: Task, change: Change)]()
        
        /// Returns the current report.
        private(set) var report: Report? = nil
        
        /// Returns all reports made by the employee.
        private(set) var reports = [Report]()
        
        var description: String {
            var returned: [String] = ["\(id). \(name)"]
            
            if subordinates.count > 0 {
                for subordinate in subordinates {
                    var nesting = "-"
                    
                    for _ in 0 ..< distance {
                        nesting += "-"
                    }
                    
                    returned.append("\(nesting) \(subordinate)")
                }
            }
            
            return returned.joined(separator: "\n")
        }
        
        //MARK: - Initialization
        /// Private employee initializer.
        private init(id: Int, name: String, head: Employee?, distance: Int) {
            self.id = id
            self.name = name
            self.head = head
            self.distance = distance
        }
        
        /// Returns new employee instance.
        static func employee(id: Int, name: String, head: Employee? = nil) -> Employee {
            var distance = 0
            
            if let h = head {
                distance = h.distance + 1
            }
            
            let employee = Employee(id: id, name: name, head: head, distance: distance)
            
            if let head = head {
                head.add(suborninate: employee)
            }
            
            return employee
        }
        
        /// Adds suborninate to current employee (this is only used for initialization).
        private func add(suborninate: Employee) {
            subordinates.append(suborninate)
        }

        /// Delegates the certain task to emloyee.
        func delegate(task: Task) {
            if delegatedTasks.contains(where: { $0 == task }) { return }
            
            delegatedTasks.append(task)
            
            if task.contructor != self {
                task.contructor.remove(task: task)
            }
            
            task.set(contructor: self)
        }
        
        /// Removes the sertain task (this is only used for redelegation).
        private func remove(task: Task) {
            guard let index = delegatedTasks.firstIndex(where: { $0 == task }) else { return }
            
            delegatedTasks.remove(at: index)
        }
        
        /// Reopens the certain task.
        func reopen(task: Task) {
            if task.state != .resolved { return }
            
            task.set(state: .open)
            changes.append((id: changes.count, task: task, change: .open(date: ReportSystem.default.date)))
        }
        
        /// Activates the first open task.
        func activate() {
            if delegatedTasks.contains(where: { $0.state == .active }) { return }
            
            if let index = delegatedTasks.firstIndex(where: { $0.state == .open }) {
                delegatedTasks[index].set(state: .active)
                changes.append((id: changes.count, task: delegatedTasks[index], change: .activate(date: ReportSystem.default.date)))
            }
        }
        
        /// Completes the active task.
        func complete() {
            if let index = delegatedTasks.firstIndex(where: { $0.state == .active }) {
                delegatedTasks[index].set(state: .resolved)
                changes.append((id: changes.count, task: delegatedTasks[index], change: .resolve(date: ReportSystem.default.date)))
            }
        }
        
        /// Creates new report's draft.
        func createReport(ofType type: ReportType, message: String) {
            switch type {
            case .day:
                guard report == nil else { return }
                
                report = Report.create(date: ReportSystem.default.date, message: message, empolyee: self)
                
            case .stage:
                if self.head == nil {
                    ReportSystem.default.projectContext.project?.create()
                }
            }
        }
        
        static func == (lhs: Employee, rhs: Employee) -> Bool {
            return lhs.id == rhs.id
        }
        
        //MARK: - Structures
        enum ReportType {
            
            /// Create a day report.
            case day
            
            /// Create a stage report.
            case stage
        }
    }
}
