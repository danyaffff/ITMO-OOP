//
//  Task.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.ProjectContext.Project.Stage {
    
    final class Task: Equatable {
        
        typealias Stage = ReportSystem.ProjectContext.Project.Stage
        typealias Employee = ReportSystem.EmployeesContext.Employee
        
        //MARK: - Properties
        /// Returns the task id.
        let id: Int
        
        /// Returns the task's state.
        private(set) var state: TaskState = .open
        
        /// Returns the stage the task is in.
        let stage: Stage
        
        /// Returns the task's contructor.
        private(set) var contructor: Employee
        
        /// Returns the task's message.
        private(set) var message: String
        
        //MARK: - Initialization
        /// Private initilizator.
        private init(id: Int, message: String, contructor: Employee, stage: Stage) {
            self.id = id
            self.message = message
            self.contructor = contructor
            self.stage = stage
        }
        
        //MARK: - Methods
        /// Returns new task instance
        static func task(id: Int, message: String, contructor: Employee, stage: Stage) -> Task {
            let task = Task(id: id, message: message, contructor: contructor, stage: stage)
            contructor.delegate(task: task)
            return task
        }
        
        /// Sets new contructor
        func set(contructor: Employee) {
            self.contructor = contructor
        }
        
        /// Sets task state.
        func set(state: TaskState) {
            self.state = state
        }
        
        static func == (lhs: Task, rhs: Task) -> Bool {
            return lhs.stage.id == rhs.stage.id && lhs.id == rhs.id
        }
        
        enum TaskState {
            case open
            case active
            case resolved
        }
        
        /// Change type.
        enum Change: Equatable {
            
            /// Opened the task.
            case open(date: Date)
            
            /// Activated the task.
            case activate(date: Date)
            
            /// Resolved the task.
            case resolve(date: Date)
        }
    }
}
