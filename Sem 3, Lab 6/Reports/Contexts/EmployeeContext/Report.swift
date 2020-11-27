//
//  File.swift
//  Reports
//
//  Created by Даниил Храповицкий on 26.11.2020.
//

import Foundation

extension ReportSystem.EmployeesContext {
    
    final class Report {
        
        typealias Task = ReportSystem.ProjectContext.Project.Stage.Task
        typealias Change = Task.Change
        
        //MARK: - Properties
        /// Returns when report was created.
        let date: Date
        
        /// Returns the report's creator.
        var employee: Employee? = nil
        
        /// Returns report's message.
        private(set) var message: String
        
        /// Returns changes was added to report.
        private(set) var changes = [(id: Int, task: Task, change: Change)]()
        
        //MARK: - Initialization
        /// Private initializator.
        private init(date: Date, message: String, employee: Employee?) {
            self.date = date
            self.message = message
            self.employee = employee
        }
        
        //MARK: - Methods
        static func create(date: Date, message: String, empolyee: Employee?) -> Report {
            return Report(date: date, message: message, employee: empolyee)
        }
        
        /// Synchronizes the changes.
        func synchronize() {
            guard let _ =  employee else { return }
            for change in employee!.changes {
                if !changes.contains(where: { $0.id == change.id }) {
                    changes.append(change)
                }
            }
        }
        
        func edit(field: Field) {
            switch field {
            case .message(let text):
                message = text
            }
        }
        
        //MARK: - Structures
        enum Field {
            
            /// Edit message.
            case message(text: String)
        }
    }
}
