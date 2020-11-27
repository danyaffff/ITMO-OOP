//
//  ProjectContext.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem {
    
    final class ProjectContext {
        
        /// Returns the current project.
        private(set) var project: Project? = nil
        
        /// Creates the new project
        func createProject() -> Project? {
            guard project == nil else { return nil }
            project = Project.project()
            return project
        }
    }
}