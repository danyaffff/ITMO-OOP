//
//  Employee.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.EmployeesContext {
    /**
     An interface that allows you to interact with an employee.
     */
    public final class Employee: Equatable, CustomStringConvertible {
        
        public typealias Stage = ReportSystem.ProjectContext.Project.Stage
        public typealias Task = ReportSystem.ProjectContext.Project.Stage.Task
        public typealias TaskRepresentation = Stage.TaskRepresentation
        
        //MARK: - Properties
        /// Returns the id of employee.
        public let id: Int
        
        /// Returns the name of employee.
        public let name: String
        
        /// Returns the head of employee.
        private(set) public var head: Employee?
        
        /// Returns distance from team leader.
        private(set) fileprivate var distance: Int
        
        /// Returns the subordinates of employee.
        private(set) public var subordinates = [Employee]()
        
        /// Returns tasks that delegated to current employee.
        private(set) public var delegatedTasks = [Task]()

        /// Returns the unsynchronized changes.
        internal(set) public var changes = [(id: Int, task: Task, change: Change)]()

        /// Returns the current report.
        internal(set) public var report: Report? = nil
        
        /// Returns report of subordinates changes.
        private(set) public var subordinatesReport: StageReport? = nil
        
        /// Returns all reports made by the employee.
        internal(set) public var reports = [Report]()
        
        public var description: String {
            var returned = [String](arrayLiteral: "▿ \(name)")
            
            if subordinates.count > 0 {
                for subordinate in subordinates {
                    var nesting = " "
                    
                    for _ in 0 ..< distance {
                        nesting += "  "
                    }
                    
                    returned.append("\(nesting) \(subordinate)")
                }
            }
            
            return returned.joined(separator: "\n")
        }
        
        //MARK: - Initializer
        /// Private employee initializer.
        private init(id: Int, name: String, head: Employee?, distance: Int) {
            self.id = id
            self.name = name
            self.head = head
            self.distance = distance
        }
        
        //MARK: - Methods
        /// Returns new employee instance.
        public class func employee(id: Int, name: String, head: Employee? = nil) -> Employee {
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
        public func delegate(task: Task) {
            if delegatedTasks.contains(where: { $0 == task }) { return }

            delegatedTasks.append(task)

            if task.employee != self {
                task.employee.remove(task: task)
            }
            changes.append((id: changes.count, task: task, change: .employee(date: ReportSystem.default.date, employee: task.employee)))
            task.set(employee: self)
        }
        
        /// Adds new tasks to the certain stage.
        public func add(to stage: Stage, tasks: [TaskRepresentation]) {
            stage.add(tasks: tasks)
            
            for task in stage.tasks[stage.tasks.count - tasks.count ..< stage.tasks.count] {
                changes.append((id: changes.count, task: task, change: .add(date: ReportSystem.default.date, employee: self)))
            }
        }

        /// Removes the certain task (this is only used for redelegation).
        private func remove(task: Task) {
            guard let index = delegatedTasks.firstIndex(where: { $0 == task }) else { return }

            delegatedTasks.remove(at: index)
        }

        /// Reopens the certain task.
        public func reopen(task: Task) {
            if task.state != .resolved { return }

            task.set(state: .open)
            changes.append((id: changes.count, task: task, change: .open(date: ReportSystem.default.date, employee: self)))
        }

        /// Activates the first open task.
        public func activate(at id: Int? = nil) {
            if delegatedTasks.contains(where: { $0.state == .active }) { return }

            var task: Task
            
            if let _ = id {
                if let index = delegatedTasks.firstIndex(where: { $0.id == id! }) {
                    delegatedTasks[index].set(state: .active)
                    task = delegatedTasks[index]
                } else { return }
            } else {
                if let index = delegatedTasks.firstIndex(where: { $0.state == .open }) {
                    delegatedTasks[index].set(state: .active)
                    task = delegatedTasks[index]
                } else { return }
            }
            
            changes.append((id: changes.count, task: task, change: .activate(date: ReportSystem.default.date, employee: self)))
        }

        /// Completes the active task.
        public func complete(at id: Int? = nil) {
            if let index = delegatedTasks.firstIndex(where: { $0.state == .active }) {
                delegatedTasks[index].set(state: .resolved)
                changes.append((id: changes.count, task: delegatedTasks[index], change: .resolve(date: ReportSystem.default.date, employee: self)))
            }
        }

        /// Creates new report's draft.
        public func createReport(title: String, message: String, type: ReportType) {
            guard report == nil else { return }
            
            switch type {
            case .day:
                report = DailyReport.create(id: ReportSystem.default.projectContext.project!.numberOfReports, title: title, message: message, date: ReportSystem.default.date, employee: self)
                ReportSystem.default.projectContext.project!.numberOfReports += 1

            case .stage:
                guard let _ = ReportSystem.default.projectContext.project?.stage else { return }
                if ReportSystem.default.projectContext.project!.stage!.tasks.contains(where: { $0.state != .resolved }) { return }
                
                report = StageReport.create(id: ReportSystem.default.projectContext.project!.stageReports.count, title: title, message: message, date: ReportSystem.default.date, employee: self)
            }
        }
        
        /// Checks if self is a subordinate employee.
        internal func isSubordinate(of employee: Employee) -> Bool {
            if self.head == nil { return false }
            
            if self.head == employee {
                return true
            } else {
                return self.head!.isSubordinate(of: employee)
            }
        }

        public static func == (lhs: Employee, rhs: Employee) -> Bool {
            return lhs.id == rhs.id
        }
    }
}
