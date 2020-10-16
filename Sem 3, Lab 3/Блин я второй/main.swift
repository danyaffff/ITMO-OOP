//
//  main.swift
//  Блин я второй
//
//  Created by Даниил Храповицкий on 27.09.2020.
//

import Foundation

let manager = RaceManager()

manager.createVehicle(name: "Двугорбый верблюд", speed: 10, restInterval: 30, restDuration: .firstIsDifferent(first: 5, remaining: 8))
manager.createVehicle(name: "Верблюд-быстроход", speed: 40, restInterval: 10, restDuration: .theFirstTwoAreDifferent(first: 5, second: 7, remaining: 8))
manager.createVehicle(name: "Кентавр", speed: 15, restInterval: 2, restDuration: .every(2))
manager.createVehicle(name: "Ботинки-вездеходы", speed: 6, restInterval: 60, restDuration: .firstIsDifferent(first: 10, remaining: 5))
manager.createVehicle(name: "Ковёр-самолёт", speed: 10, distanceReduction: .dependsOnDistance(firstDistance: 1000, firstPercent: 0, secondDistance: 5000, secondPercent: 10, thirdDistance: 10000, thirdPercent: 5))
manager.createVehicle(name: "Ступа", speed: 8, distanceReduction: .const(percent: 6))
manager.createVehicle(name: "Метла", speed: 20, distanceReduction: .uniform(percent: 1, every: 1000))

print(manager, terminator: "\n\n")

print("Гонка создана: \(manager.isRaceCreated)", terminator: "\n\n")

print("Создаем гонку............", terminator: "\n\n")
manager.createRace(withVehicles: .all, distance: 20000)

print("Гонка создана: \(manager.isRaceCreated)", terminator: "\n\n")

print("Регестрируем транспорт..............")
manager.registerVehicle(manager.vehicles[2])
manager.registerVehicle(manager.vehicles[0])
manager.registerVehicle(manager.vehicles[4])
manager.registerVehicle(manager.vehicles[6])

print("Транспорт в гонке")
manager.returnVehiclesInRace()

print("Отмечаем регистрацию одному ТС", terminator: "\n\n")
manager.unregisterVehicle(manager.vehicles[2])

print("Снова выводим транспорт в гонке")
manager.returnVehiclesInRace()

print("Старт симуляции............", terminator: "\n\n")

print("Победитель: ", terminator: "")
manager.start()
