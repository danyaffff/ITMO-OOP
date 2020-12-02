//
//  Project.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.ProjectContext {
    /**
     An interface that allows you to work on a project, giving access to viewing and managing development stages and tasks.
     */
    public final class Project: CustomStringConvertible {
        
        public typealias TaskRepresentation = ReportSystem.ProjectContext.Project.Stage.TaskRepresentation
        public typealias Employee = ReportSystem.EmployeesContext.Employee
        public typealias Task = ReportSystem.ProjectContext.Project.Stage.Task
        public typealias DailyReport = ReportSystem.EmployeesContext.DailyReport
        public typealias StageReport = ReportSystem.EmployeesContext.StageReport
        
        //MARK: - Properties
        private(set) public var name: String
        
        /// Returns the project's stages.
        private(set) public var stages = [Stage]()
        
        /// Returns the current stage.
        private(set) public var stage: Stage? = nil
        
        /// Returns the closded daily reports.
        internal(set) public var dailyReports = [DailyReport]()
        
        /// Returns the closed stage reports.
        internal(set) public var stageReports = [StageReport]()
        
        /// Returns the real number of reports.
        internal var numberOfReports: Int = 0
        
        public var description: String {
            var returned = [String](arrayLiteral: "▿ \(name)")
            
            if stages.count > 0 {
                for stage in stages {
                    returned.append("  \(stage)")
                }
            }
            
            return returned.joined(separator: "\n")
        }
        
        //MARK: - Initializer
        /// Private initializatior.
        private init(name: String) {
            self.name = name
        }
        
        //MARK: - Methods
        /// Returns new project instance.
        public class func project(name: String) -> Project {
            return Project(name: name)
        }
        
        /// Adds new stages to project.
        public func add(stages: [StageRepresentation]) -> Project? {
            guard self.stages.isEmpty else { return nil }
            
            for stage in stages {
                switch stage {
                case .stage(let message, let tasks):
                    let newStage = Stage.stage(id: self.stages.count, message: message)
                    newStage.add(tasks: tasks)
                    
                    self.stages.append(newStage)
                }
            }
            
            stage = self.stages[safe: 0]
            
            return self
        }
        
        /// Returns an array of tasks that satisfy the given condition.
        public func serach(by condition: SearchCondidtion) -> [Task?] {
            switch condition {
            case .id(let stageID, let taskID):
                return [stages[safe: stageID]?.tasks[safe: taskID]]
            case .time(let type, let date):
                return searchTasks(of: type, with: date)
            case .employee(let employee):
                return employee.delegatedTasks
            case .employeeChange(let employee):
                return searchTasks(employee: employee)
            case .subordinatesTasks(let employee):
                return searchTasksWhichDelegetedToSubordinatesOf(employee: employee)
            }
        }
        
        /// Returns an array of tasks that satisfy the given arguments
        private func searchTasks(of type: TimeSearch? = nil, with date: Date? = nil, employee: Employee? = nil) -> [Task] {
            var returned = [Task]()
            
            var predicate: (Task) -> Bool
            
            if let _ = employee {
                predicate = { (task) -> Bool in
                    task.changes.contains(where: { $0.getEmployee() == employee! })}
            } else {
                switch type! {
                case .creation:
                    predicate = { $0.creation.compare(with: date!) }
                case .change:
                    predicate = { $0.changes.last?.getDate().compare(with: date!) ?? false }
                }
            }
            
            for stage in stages {
                returned.append(contentsOf: stage.tasks.filter(predicate))
            }
            
            return returned
        }
        
        private func searchTasksWhichDelegetedToSubordinatesOf(employee: Employee) -> [Task] {
            var returned = [Task]()
            
            for subordinate in employee.subordinates {
                returned.append(contentsOf: subordinate.delegatedTasks)
            }
            
            return returned
        }
        
        /// Represents main stage fields.
        public enum StageRepresentation {
            
            /// Stage representation.
            case stage(message: String, tasks: [TaskRepresentation])
        }
        
        /// Sets conditions for tasks searching.
        public enum SearchCondidtion {
            
            /// Serach by id.
            case id(stageID: Int, taskID: Int)
            
            /// Serach by creation time/last change..
            case time(type: TimeSearch, date: Date)
            
            /// Serach by employee.
            case employee(Employee)
            
            /// Serach by employee changes.
            case employeeChange(Employee)
            
            /// Search by subordinates.
            case subordinatesTasks(Employee)
        }
        
        /// Type of time searching.
        public enum TimeSearch {
            
            /// Search by creation time.
            case creation
            
            /// Search by last change time.
            case change
        }
    }
}
