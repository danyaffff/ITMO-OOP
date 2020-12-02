//
//  ProjectContext.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

extension ReportSystem {
    
    /**
     An interface that allows you to create a project and access the created project.
     */
    public final class ProjectContext: CustomStringConvertible {
        
        //MARK: - Properties
        /// Returns the current project.
        private(set) public var project: Project? = nil
        
        public var description: String {
            return project?.description ?? ""
        }
        
        //MARK: - Methods
        /// Creates the new project
        public func createProject(name: String) -> Project? {
            guard project == nil else { return nil }
            project = Project.project(name: name)
            return project
        }
    }
}
