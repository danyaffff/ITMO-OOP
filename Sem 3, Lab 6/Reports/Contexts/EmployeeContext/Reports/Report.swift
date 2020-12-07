//
//  File.swift
//  Reports
//
//  Created by Даниил Храповицкий on 26.11.2020.
//

import Foundation

extension ReportSystem.EmployeesContext {
    
    /**
     A basic interface that allows you to structure the concept of a report.
     */
    public class Report: Equatable {
        
        //MARK: - Properties
        /// Returns the unique identifier.
        private(set) public var id: Int
        
        /// Returns the title of report.
        private(set) public var title: String
        
        /// Returns the description of report.
        private(set) public var message: String
        
        /// Returns when report was created.
        private(set) public var date: Date
        
        /// Returns the creator of report.
        private(set) public var employee: Employee
        
        /// Returns the state of report.
        private(set) public var state: State = .open
        
        /// Returns the type of report.
        private(set) public var type: ReportType
        
        /// Returns self as daily report.
        public var asDailyReport: DailyReport {
            return self as! DailyReport
        }
        
        /// Returns self as stage report.
        public var asStageReport: StageReport {
            return self as! StageReport
        }
        
        //MARK: - Initilizer
        internal init(id: Int, title: String, message: String, date: Date, employee: Employee, type: ReportType) {
            self.id = id
            self.title = title
            self.message = message
            self.date = date
            self.employee = employee
            self.type = type
        }
        
        //MARK: - Methods
        
        /// Edits data in field.
        public func edit(field: Field) {
            guard state == .open else { return }
            
            switch field {
            case .title(let text):
                title = text
                
            case .message(let text):
                message = text
            }
        }
        
        /// Closes report for editting.
        internal func close() {
            guard state == .open else { return }
            
            state = .close
            employee.report = nil
            employee.reports.append(self)
            
            switch type {
            case .day:
                ReportSystem.default.projectContext.project!.dailyReports.append(self as! ReportSystem.ProjectContext.Project.DailyReport)
            case .stage:
                ReportSystem.default.projectContext.project!.stageReports.append(self as! ReportSystem.ProjectContext.Project.StageReport)
            }
        }
        
        public static func == (lhs: Report, rhs: Report) -> Bool {
            return lhs.id == rhs.id
        }
        
        //MARK: - Structures
        /// Editable fields.
        public enum Field {
            
            /// Edit title.
            case title(text: String)
            
            /// Edit message.
            case message(text: String)
        }
        
        /// State of report.
        public enum State {
            
            /// Open report.
            case open
            
            /// Close report.
            case close
        }
    }
}
