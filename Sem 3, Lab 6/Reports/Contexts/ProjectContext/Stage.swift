//
//  Stage.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.ProjectContext.Project {
    
    /**
     An interface that allows you to work in detail with the development stage.
     */
    public final class Stage: CustomStringConvertible {
        
        public typealias Employee = ReportSystem.EmployeesContext.Employee
        
        //MARK: - Properties
        /// Returns the id of stage.
        public let id: Int
        
        /// Returns the tasks in stage.
        private(set) public var tasks = [Task]()
        
        /// Returns the added message.
        private(set) public var message: String
        
        public var description: String {
            var returned = [String](arrayLiteral: "▿ \(message)")
            
            if tasks.count > 0 {
                for task in tasks {
                    returned.append("    \(task)")
                }
            }
            
            return returned.joined(separator: "\n")
        }
        
        //MARK: - Initializer
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
            for task in tasks {
                switch task {
                case .task(let message, let employee):
                    self.tasks.append(Task.task(id: self.tasks.count, message: message, employee: employee, stage: self))
                    employee.delegate(task: self.tasks.last!)
                }
            }
        }
        
        //MAKR: - Structures
        /// Represents main tasks fields.
        public enum TaskRepresentation {
            
            /// Tasks representation.
            case task(message: String, contructor: Employee)
        }
    }
}
