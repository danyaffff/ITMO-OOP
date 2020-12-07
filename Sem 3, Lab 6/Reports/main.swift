//
//  main.swift
//  Reports
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation
import CoreData

let danya = ReportSystem.default.employeesContext.createEmployee(name: "Данька")!
let eugénie = ReportSystem.default.employeesContext.createEmployee(name: "Женечбка❤️", head: danya)!
let kolya = ReportSystem.default.employeesContext.createEmployee(name: "Колька", head: danya)!
let alina = ReportSystem.default.employeesContext.createEmployee(name: "Алинка", head: kolya)!
let masha = ReportSystem.default.employeesContext.createEmployee(name: "Машка", head: alina)!
let dima = ReportSystem.default.employeesContext.createEmployee(name: "СлайсОфКекус", head: eugénie)!

let project = ReportSystem.default.projectContext.createProject(name: "Проектик")!.add(stages: [
    .stage(message: "Первая стадия", tasks: [
        .task(message: "Первое задание", contructor: danya),
        .task(message: "Второе задание", contructor: eugénie)
    ]),
    .stage(message: "Вторая стадия", tasks: [
        .task(message: "Последнее задание", contructor: danya)
    ])
])!

danya.add(to: ReportSystem.default.projectContext.project!.stages[0], tasks: [
    .task(message: "Третье задание", contructor: danya)
])

danya.createReport(title: "Заголовок", message: "Описание", type: .day)

danya.activate()
danya.complete()

danya.delegatedTasks[0].edit(field: .message(text: "Измененный комментарий к заданию"))

danya.report!.edit(field: .title(text: "Измененный заголовок отчета"))

danya.report!.asDailyReport.synchronize()

ReportSystem.default.move()

danya.delegatedTasks[0].edit(field: .message(text: "Это ничего не должно поменять"))

eugénie.activate()
danya.activate(at: 2)
eugénie.complete()
danya.complete(at: 2)

eugénie.createReport(title: "Второй отчет", message: "Описание второго отчета", type: .day)
danya.createReport(title: "Третий отчет", message: "Описание", type: .day)

eugénie.report!.asDailyReport.synchronize()
danya.report!.asDailyReport.synchronize()

ReportSystem.default.move()

danya.createReport(title: "Отчет за стадию", message: "Провер_очка", type: .stage)

danya.report!.asStageReport.synchronize(of: .command)

ReportSystem.default.move()

let taskSearchedByID = ReportSystem.default.projectContext.project!.serach(by: .id(stageID: 0, taskID: 0)).first
let taskSearchedByCreation = ReportSystem.default.projectContext.project!.serach(by: .time(type: .creation, date: Date()))
let taskSearchedByEmployee = ReportSystem.default.projectContext.project!.serach(by: .employee(danya))
let taskSearchedByEmployeesChange = ReportSystem.default.projectContext.project!.serach(by: .employeeChange(danya))
let taskSearchedBySubordinates = ReportSystem.default.projectContext.project!.serach(by: .subordinatesTasks(danya))

print(ReportSystem.default)
