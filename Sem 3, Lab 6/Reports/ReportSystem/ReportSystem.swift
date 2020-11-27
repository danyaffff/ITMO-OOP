//
//  ReportSystem.swift
//  ReportSystem
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

final class ReportSystem {
    
    //MARK: - Properties
    /// Returns the singleton of Report System.
    static let `default` = ReportSystem()
    
    /// Returns emplyees context.
    let employeesContext = EmployeesContext()
    
    /// Returns project context.
    let projectContext = ProjectContext()
    
    /// Returns current date.
    private(set) var date = Date()
    
    //MARK: - Initialization
    /// Private initializator.
    private init() {}
    
    //MARK: - Methods
    /// Moves current date to Tomorrow, syncronizes completed tasks with the report and makes the team write a stage report.
    func move() {
        for employee in employeesContext.employees {
            if employee.report == nil && !employee.changes.isEmpty {
                employee.createReport(ofType: .day, message: "Репорт создан автоматически")
            }
            employee.report!.synchronize()
        }
        
        if !(projectContext.project?.stage?.tasks.contains(where: { $0.state == .active || $0.state == .open }) ?? true) {
            employeesContext.teamLeader?.createReport(ofType: .stage, message: "Отчет за стадию")
        }
        
        date += TimeInterval(60 * 60 * 24)
    }
}
