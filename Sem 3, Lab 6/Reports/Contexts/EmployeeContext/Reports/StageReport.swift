//
//  StageReport.swift
//  Reports
//
//  Created by Даниил Храповицкий on 01.12.2020.
//

import Foundation

extension ReportSystem.EmployeesContext {
    public final class StageReport: Report, CustomStringConvertible {
        
        //MARK: - Properties
        /// Returns the added reports.
        private(set) public var reports = [DailyReport]()
        
        public var description: String {
            var returned = [String]()
            
            for report in reports {
                returned.append("\(report)")
            }
            
            return returned.joined(separator: "\n")
        }
        
        //MARK: - Methods
        /// Returns new stage report instance.
        public class func create(id: Int, title: String, message: String, date: Date, employee: Employee) -> StageReport {
            return StageReport(id: id, title: title, message: message, date: date, employee: employee, type: .stage)
        }
        
        /// Synchronizes the reports.
        public func synchronize(of type: ReportType) {
            guard state == .open else { return }
            
            let dailyReports = ReportSystem.default.projectContext.project!.dailyReports
            
            switch type {
            case .employee:
                for report in dailyReports.filter({ $0.employee == employee }) {
                    if !reports.contains(where: { $0 == report }) {
                        reports.append(report)
                    }
                }
            case .command:
                for report in dailyReports {
                    if !reports.contains(where: { $0 == report && report.employee.isSubordinate(of: self.employee) }) {
                        reports.append(report)
                    }
                }
            }
        }
        
        public enum ReportType {
            case employee
            case command
        }
    }
}
