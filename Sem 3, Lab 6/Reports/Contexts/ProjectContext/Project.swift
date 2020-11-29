//
//  Project.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem.ProjectContext {
    
    final class Project {
        
        typealias TaskRepresentation = ReportSystem.ProjectContext.Project.Stage.TaskRepresentation
        typealias Report = ReportSystem.EmployeesContext.Report
        
        //MARK: - Properties
        /// Returns the project's stages.
        private(set) var stages = [Stage]()
        
        /// Returns the current stage.
        private(set) var stage: Stage? = nil
        
        /// Returns stage reports.
        private(set) var reports = [Report]()
        
        //MARK: - Initialization
        /// Private initializatior.
        private init() {}
        
        //MARK: - Methods
        /// Returns new project instance.
        static func project() -> Project {
            return Project()
        }
        
        /// Adds new stages to project.
        func add(stages: [StageRepresentation]) -> Project? {
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
        
        /// Creates the new stage report.
        func create() {
            reports.append(Report.create(date: ReportSystem.default.date, message: "Отчет за стадию", empolyee: ReportSystem.default.employeesContext.teamLeader))
        }
        
        enum StageRepresentation {
            case stage(message: String, tasks: [TaskRepresentation])
        }
    }
}
