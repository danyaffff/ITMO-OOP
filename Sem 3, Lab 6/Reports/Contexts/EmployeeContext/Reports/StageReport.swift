//
//  StageReport.swift
//  Reports
//
//  Created by Даниил Храповицкий on 01.12.2020.
//

import Foundation

extension ReportSystem.EmployeesContext {
    public final class StageReport: Report {
        
        //MARK: - Properties
        /// Returns the added reports.
        private(set) public var reports = [DailyReport]()
        
        //MARK: - Methods
        /// Returns new stage report instance.
        public class func create(id: Int, title: String, message: String, date: Date, employee: Employee) -> StageReport {
            return StageReport(id: id, title: title, message: message, date: date, employee: employee, type: .stage)
        }
        
        /// Synchronizes the reports.
        override public func synchronize() {
            guard state == .open else { return }
            
            let dailyReports = ReportSystem.default.projectContext.project!.dailyReports
            
            switch employee.head {
            case nil:
                for report in dailyReports {
                    if !reports.contains(where: { $0 == report }) {
                        reports.append(report)
                    }
                }
            default:
                for report in dailyReports.filter({ $0.employee == employee }) {
                    if !reports.contains(where: { $0 == report }) {
                        reports.append(report)
                    }
                }
            }
        }
    }
}
