//
//  Stage.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.ProjectContext.Project {
    
    final class Stage {
        
        typealias Employee = ReportSystem.EmployeesContext.Employee
        
        //MARK: - Properties
        /// Returns the id of stage.
        let id: Int
        
        /// Returns the tasks in stage.
        private(set) var tasks = [Task]()
        
        /// Returns the added message.
        private(set) var message: String
        
        //MARK: - Initialization
        /// Private initializator.
        private init(id: Int, message: String) {
            self.id = id
            self.message = message
        }
        
        //MARK: - Methods
        /// Returns new stage instance.
        static func stage(id: Int, message: String) -> Stage {
            return Stage(id: id, message: message)
        }
        
        func add(tasks: [TaskRepresentation]) {
            for (index, task) in tasks.enumerated() {
                switch task {
                case .task(let message, let contructor):
                    self.tasks.append(Task.task(id: index, message: message, contructor: contructor, stage: self))
                }
            }
        }
        
        enum TaskRepresentation {
            case task(message: String, contructor: Employee)
        }
    }
}
