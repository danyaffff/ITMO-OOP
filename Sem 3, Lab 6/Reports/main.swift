//
//  main.swift
//  Reports
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

let danya = ReportSystem.default.employeesContext.createEmployee(name: "Данбка")!
let project = ReportSystem.default.projectContext.createProject()!.add(stages: [
    .stage(message: "Первая стадия", tasks: [
        .task(message: "Первое задание", contructor: danya),
        .task(message: "Второе задание", contructor: danya)
    ]),
    .stage(message: "Вторая стадия", tasks: [
        .task(message: "Последнее задание", contructor: danya)
    ])
])!

project.stages[0].add(tasks: [
    .task(message: "Третье задание", contructor: danya)
])

danya.createReport(title: "Заголовок", message: "Описание", type: .day)

ReportSystem.default
