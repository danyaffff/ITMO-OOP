//
//  Project.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.ProjectContext {
    
    public final class Project {
        
        public typealias TaskRepresentation = ReportSystem.ProjectContext.Project.Stage.TaskRepresentation
        public typealias DailyReport = ReportSystem.EmployeesContext.DailyReport
        public typealias StageReport = ReportSystem.EmployeesContext.StageReport
        
        //MARK: - Properties
        /// Returns the project's stages.
        private(set) public var stages = [Stage]()
        
        /// Returns the current stage.
        private(set) public var stage: Stage? = nil
        
        /// Returns closded daily reports
        internal(set) public var dailyReports = [DailyReport]()
        
        /// Returns closed stage reports.
        internal(set) public var stageReports = [StageReport]()
        
        /// Returns the real number of reports
        internal var numberOfReports: Int = 0
        
        //MARK: - Initialization
        /// Private initializatior.
        private init() {}
        
        //MARK: - Methods
        /// Returns new project instance.
        public class func project() -> Project {
            return Project()
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
        
        /// Represents main stage fields.
        public enum StageRepresentation {
            
            /// Stage representation.
            case stage(message: String, tasks: [TaskRepresentation])
        }
    }
}
