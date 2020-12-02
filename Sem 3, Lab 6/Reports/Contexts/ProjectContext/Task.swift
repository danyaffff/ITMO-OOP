//
//  Task.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.ProjectContext.Project.Stage {
    
    /**
     An interface that allows you to work with the task in detail
     */
    public final class Task: Equatable, CustomStringConvertible {
        
        public typealias Stage = ReportSystem.ProjectContext.Project.Stage
        public typealias Change = ReportSystem.EmployeesContext.Change
        
        //MARK: - Properties
        /// Returns the task id.
        public let id: Int
        
        /// Returns the task's state.
        private(set) public var state: TaskState = .open
        
        /// Returns the stage the task is in.
        public let stage: Stage
        
        /// Returns the contructor of task.
        private(set) public var employee: Employee
        
        /// Returns the message of task.
        private(set) public var message: String
        
        /// Returns the changes.
        private(set) internal var changes = [Change]()
        
        /// Returns the creation time.
        let creation: Date
        
        public var description: String {
            return "▿ \(message) is \(state)"
        }
        
        //MARK: - Initializer
        /// Private initilizator.
        private init(id: Int, message: String, employee: Employee, stage: Stage, creation: Date) {
            self.id = id
            self.message = message
            self.employee = employee
            self.stage = stage
            self.creation = creation
        }
        
        //MARK: - Methods
        /// Returns new task instance
        public class func task(id: Int, message: String, employee: Employee, stage: Stage) -> Task {
            let task = Task(id: id, message: message, employee: employee, stage: stage, creation: ReportSystem.default.date)
            employee.delegate(task: task)
            return task
        }
        
        /// Sets new contructor
        internal func set(employee: Employee) {
            changes.append(.employee(date: ReportSystem.default.date, employee: self.employee))
            self.employee = employee
        }
        
        /// Sets task state.
        internal func set(state: TaskState) {
            switch state {
            case .open:
                changes.append(.open(date: ReportSystem.default.date, employee: employee))
            case .active:
                changes.append(.activate(date: ReportSystem.default.date, employee: employee))
            case .resolved:
                changes.append(.resolve(date: ReportSystem.default.date, employee: employee))
            }
            self.state = state
        }
        
        public func edit(field: Field) {
            guard state != .resolved else { return }
            
            switch field {
            case .message(let text):
                message = text
                employee.changes.append((id: employee.changes.count, task: self, change: .message(date: ReportSystem.default.date, employee: employee)))
                changes.append(.message(date: ReportSystem.default.date, employee: employee))
            }
        }
        
        public static func == (lhs: Task, rhs: Task) -> Bool {
            return lhs.stage.id == rhs.stage.id && lhs.id == rhs.id
        }
        
        /// Tasks state.
        public enum TaskState: CustomStringConvertible {
            
            /// Task open.
            case open
            
            /// Task active.
            case active
            
            /// Task resolved.
            case resolved
            
            public var description: String {
                switch self {
                case .open:
                    return "opened"
                case .active:
                    return "actived"
                case .resolved:
                    return "resolved"
                }
            }
        }
        
        //MARK: - Structures
        public enum Field {
            case message(text: String)
        }
    }
}
