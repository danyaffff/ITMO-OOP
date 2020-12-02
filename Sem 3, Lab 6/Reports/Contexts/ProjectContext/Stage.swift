//
//  Stage.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.ProjectContext.Project {
    
    public final class Stage {
        
        public typealias Employee = ReportSystem.EmployeesContext.Employee
        
        //MARK: - Properties
        /// Returns the id of stage.
        public let id: Int
        
        /// Returns the tasks in stage.
        private(set) public var tasks = [Task]()
        
        /// Returns the added message.
        private(set) public var message: String
        
        //MARK: - Initialization
        /// Private initializator.
        private init(id: Int, message: String) {
            self.id = id
            self.message = message
        }
        
        //MARK: - Methods
        /// Returns new stage instance.
        public class func stage(id: Int, message: String) -> Stage {
            return Stage(id: id, message: message)
        }
        
        /// Adds new tasks to current stage.
        internal func add(tasks: [TaskRepresentation]) {
            for (index, task) in tasks.enumerated() {
                switch task {
                case .task(let message, let contructor):
                    self.tasks.append(Task.task(id: index, message: message, employee: contructor, stage: self))
                }
            }
        }
        
        /// Represents main tasks fields.
        public enum TaskRepresentation {
            
            /// Tasks representation.
            case task(message: String, contructor: Employee)
        }
    }
}
