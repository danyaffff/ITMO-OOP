//
//  Task.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.ProjectContext.Project.Stage {
    
    public final class Task: Equatable {
        
        public typealias Stage = ReportSystem.ProjectContext.Project.Stage
        public typealias Employee = ReportSystem.EmployeesContext.Employee
        
        //MARK: - Properties
        /// Returns the task id.
        public let id: Int
        
        /// Returns the task's state.
        private(set) public var state: TaskState = .open
        
        /// Returns the stage the task is in.
        public let stage: Stage
        
        /// Returns the task's contructor.
        private(set) public var employee: Employee
        
        /// Returns the task's message.
        private(set) public var message: String
        
        //MARK: - Initialization
        /// Private initilizator.
        private init(id: Int, message: String, contructor: Employee, stage: Stage) {
            self.id = id
            self.message = message
            self.employee = contructor
            self.stage = stage
        }
        
        //MARK: - Methods
        /// Returns new task instance
        public class func task(id: Int, message: String, contructor: Employee, stage: Stage) -> Task {
            let task = Task(id: id, message: message, contructor: contructor, stage: stage)
            contructor.delegate(task: task)
            return task
        }
        
        /// Sets new contructor
        internal func set(employee: Employee) {
            self.employee = employee
        }
        
        /// Sets task state.
        internal func set(state: TaskState) {
            self.state = state
        }
        
        public func edit(field: Field) {
            guard state != .resolved else { return }
            
            switch field {
            case .message(let text):
                message = text
                employee.changes.append((id: employee.changes.count, task: self, change: .message(date: ReportSystem.default.date, employee: employee)))
            }
        }
        
        public static func == (lhs: Task, rhs: Task) -> Bool {
            return lhs.stage.id == rhs.stage.id && lhs.id == rhs.id
        }
        
        /// Tasks state.
        public enum TaskState {
            
            /// Task open.
            case open
            
            /// Task active.
            case active
            
            /// Task resolved.
            case resolved
        }
        
        //MARK: - Structures
        public enum Field {
            case message(text: String)
        }
    }
}
