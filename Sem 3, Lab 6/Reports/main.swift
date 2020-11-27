//
//  main.swift
//  Reports
//
//  Created by Даниил Храповицкий on 22.11.2020.
//

import Foundation

//let danya = ReportSystem.default.employeesContext.createEmployee(name: "Данбка")
//let eugénie = ReportSystem.default.employeesContext.createEmployee(name: "Женбка❤️", head: danya)
//if let danya = danya, let eugénie = eugénie {
//    let project = ReportSystem.default.projectContext.createProject()?.add(stages: [
//        .stage(message: "Первая стадия разработки", tasks: [
//            .task(message: "Первое задание первой стадии", contructor: danya),
//            .task(message: "Второе задание первой стадии разработки", contructor: eugénie)
//        ]),
//        .stage(message: "Вторая стадия разработки", tasks: [
//            .task(message: "Первое задание второй стадии разработки", contructor: eugénie)
//        ]),
//        .stage(message: "Заключительная стадия разработки", tasks: [
//            .task(message: "Последнее задание", contructor: danya)
//        ])
//    ])
//
//    if let task = ReportSystem.default.projectContext.project?.stages[0].tasks[1] {
//        danya.delegate(task: task)
//    }
//
//    danya.activate()
//    eugénie.activate()
//
//    danya.complete()
//    da
//}

let danya = ReportSystem.default.employeesContext.createEmployee(name: "Данбка")!
let project = ReportSystem.default.projectContext.createProject()!.add(stages: [
    .stage(message: "Первая стадия", tasks: [
        .task(message: "Первое задание", contructor: danya),
        .task(message: "Второе задание", contructor: danya)
    ]),
    .stage(message: "Вторая стадия", tasks: [
        .task(message: "Последнее задание", contructor: danya)
    ])
])

danya.activate()  // Активирует первое задание

danya.complete()  // Выполняет первое задание

//danya.createReport(message: "Репорт за первый день")  // Создает репорт

print(danya.changes)

//danya.report!.synchronize()  // Синхронизирует репорт и выполненые задания

ReportSystem.default.move()  // Двигает время до завтра и автоматически синхронизирует изменения

ReportSystem.default
