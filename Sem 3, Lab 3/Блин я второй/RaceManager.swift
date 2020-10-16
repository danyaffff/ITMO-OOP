//
//  RaceManager.swift
//  Блин я второй
//
//  Created by Даниил Храповицкий on 27.09.2020.
//

import Foundation

class RaceManager: CustomStringConvertible {
    private(set) var vehicles: [Vehicle] = []
    private(set) fileprivate var race: Race? = nil
    
    /// Check race creation
    var isRaceCreated: Bool {
        get {
            if let _ = race {
                return true
            } else {
                return false
            }
        }
    }
    
    enum VehiclesType {
        case all
        case ground
        case air
    }
    
    enum Winer {
        case one(vehicle: Vehicle)
        case many(vehicles: [Vehicle])
    }
    
    enum GroundVehicleStopType {
        case every(UInt)
        case firstIsDifferent(first: UInt, remaining: UInt)
        case theFirstTwoAreDifferent(first: UInt, second: UInt, remaining: UInt)
    }
    
    enum AirVehicleDistanceReducingType {
        case dependsOnDistance(firstDistance: UInt, firstPercent: UInt, secondDistance: UInt, secondPercent: UInt, thirdDistance: UInt, thirdPercent: UInt)
        case const(percent: UInt)
        case uniform(percent: UInt, every: UInt)
    }
    
    /// Create a Ground vehicle.
    func createVehicle(name: String, speed: UInt, restInterval: UInt, restDuration: GroundVehicleStopType) {
        if let _ = vehicles.firstIndex(where: { $0.name == name }) { return }
        vehicles.append(GroundVehicle(name: name, speed: speed, restInterval: restInterval, restDuration: restDuration))
    }
    
    /// Create an Air vehicle.
    func createVehicle(name: String, speed: UInt, distanceReduction: AirVehicleDistanceReducingType) {
        if let _ = vehicles.firstIndex(where: { $0.name == name }) { return }
        vehicles.append(AirVehicle(name: name, speed: speed, distanceReduction: distanceReduction))
    }
    
    /// Create race.
    func createRace(withVehicles type: VehiclesType, distance: UInt) {
        race = Race(vehiclesType: type, distance: distance)
    }
    
    /// Delete race.
    func deleteRace() {
        race = nil
    }
    
    /// Register vehicle for the race.
    func registerVehicle(_ vehicle: Vehicle) {
        guard let race = race else { return }
        if race.type == .all || race.type == vehicle.type {
            race.add(vehicle: vehicle)
        }
    }
    
    /// Unregister vehicle.
    func unregisterVehicle(_ vehicle: Vehicle) {
        guard let race = race else { return }
        race.delete(vehicle: vehicle)
    }
    
    /// Start race simulation.
    func start() {
        guard let race = race else { return }
        if let winer = race.start() {
            if case let .one(vehicle: vehicle) = winer {
                print(vehicle.name)
            } else if case let .many(vehicles: vehicles) = winer {
                for vehicle in vehicles {
                    print(vehicle.name)
                }
            }
        } else {
            print("Не удалось вычислить победителя!")
        }
        
    }
    
    /// Return all registered vehicles.
    func returnVehiclesInRace() {
        guard let race = race else { return }
        race.print()
    }
    
    // (((пере)))определение вывода
    var description: String {
        var returnedString: [String] = []
        
        for index in vehicles.indices {
            if type(of: vehicles[index]) == GroundVehicle.self {
                if case let .every(value) = (vehicles[index] as! GroundVehicle).restDuration {
                    returnedString.append("\(index): [Наземеный транспорт] \"\(vehicles[index].name)\" — скорость: \(vehicles[index].speed) м/с; время до отдыха: \((vehicles[index] as! GroundVehicle).restInterval) с; отдых: всегда \(value) с")
                } else if case let .firstIsDifferent(first: firstValue, remaining: remainingValues) = (vehicles[index] as! GroundVehicle).restDuration {
                    returnedString.append("\(index): [Наземеный транспорт] \"\(vehicles[index].name)\" — скорость: \(vehicles[index].speed) м/с; время до отдыха: \((vehicles[index] as! GroundVehicle).restInterval) с; отдых в первый раз: \(firstValue) с, в остальные разы: \(remainingValues) с")
                } else if case let .theFirstTwoAreDifferent(first: firstValue, second: secondValue, remaining: remainingValues) = (vehicles[index] as! GroundVehicle).restDuration {
                    returnedString.append("\(index): [Наземеный транспорт] \"\(vehicles[index].name)\" — скорость: \(vehicles[index].speed) м/с; время до отдыха: \((vehicles[index] as! GroundVehicle).restInterval) с; отдых в первый раз: \(firstValue) с, во второй: \(secondValue) с, в остальные разы: \(remainingValues) с")
                }
            } else {
                if case let .dependsOnDistance(firstDistance: firstValue, firstPercent: firstPercent, secondDistance: secondValue, secondPercent: secondPercent, thirdDistance: thirdValue, thirdPercent: thirdPercent) = (vehicles[index] as! AirVehicle).distanceReduction {
                    returnedString.append("\(index): [Воздушный транспорт] \"\(vehicles[index].name)\" - \(vehicles[index].speed) м/с; сокращение расстояния: до \(firstValue) м — \(firstPercent)%, до \(secondValue) м — \(secondPercent)%, до \(thirdValue) м — \(thirdPercent)%")
                } else if case let .const(percent: percent) = (vehicles[index] as! AirVehicle).distanceReduction {
                    returnedString.append("\(index): [Воздушный транспорт] \"\(vehicles[index].name)\" - \(vehicles[index].speed) м/с; сокращение расстояния: всегда \(percent)%")
                } else if case let .uniform(percent: percent, every: distance) = (vehicles[index] as! AirVehicle).distanceReduction {
                    returnedString.append("\(index): [Воздушный транспорт] \"\(vehicles[index].name)\" - \(vehicles[index].speed) м/с; сокращение расстояния: \(percent)% на \(distance) м")
                }
            }
        }
        
        return returnedString.joined(separator: "\n")
    }
}

extension RaceManager {
    final class Race {
        private(set) var vehicles: [Vehicle] = []
        private(set) var distance: UInt
        private(set) var type: VehiclesType
        
        private enum Parameters {
            case reducedDistance(UInt)
            case stopParameters(stopNumber: UInt, restDuration: UInt, restInterval: UInt)
        }
        
        fileprivate init(vehiclesType type: VehiclesType, distance: UInt) {
            self.type = type
            self.distance = distance
        }
        
        fileprivate func add(vehicle: Vehicle) {
            vehicles.append(vehicle)
        }
        
        fileprivate func start() -> Winer? {
            var categorizedVehicels: [(vehicle: Vehicle, coveredDistance: UInt, parameters: Parameters)] = []
            var finishedVehicles: [Vehicle] = []  // Транспорты, пересекшие финишную черту
            
            for vehicle in vehicles {
                if Swift.type(of: vehicle) == GroundVehicle.self {
                    categorizedVehicels.append((vehicle: vehicle, coveredDistance: 0, parameters: .stopParameters(stopNumber: 0, restDuration: 0, restInterval: (vehicle as! GroundVehicle).restInterval)))
                } else {
                    var distance: UInt = 0
                    
                    if case let .dependsOnDistance(firstDistance: firstDistance, firstPercent: firstPercent, secondDistance: _, secondPercent: secondPercent, thirdDistance: thirdDistance, thirdPercent: thirdPercent) = (vehicle as! AirVehicle).distanceReduction {
                        let percent = Double(self.distance > thirdDistance ? thirdPercent : self.distance < firstDistance ? firstPercent : secondPercent)
                        
                        distance = UInt(Double(self.distance) * (1 - (percent / 100)))
                    } else if case let .const(percent: percent) = (vehicle as! AirVehicle).distanceReduction {
                        distance = UInt(Double(self.distance) * (1 - (Double(percent) / 100)))
                    } else if case let .uniform(percent: percent, every: firstDistance) = (vehicle as! AirVehicle).distanceReduction {
                        var tempDistance = self.distance
                        var counter = 0
                        
                        while (Int(tempDistance) - Int(firstDistance)) > (Int(firstDistance) - 1) {
                            counter += 1
                            tempDistance -= firstDistance
                        }
                        
                        distance = UInt(Double(self.distance) *  (1 - Double(counter) * (Double(percent) / 1000)))
                    }
                    
                    categorizedVehicels.append((vehicle: vehicle, coveredDistance: 0, parameters: .reducedDistance(distance)))
                }
            }
            
            if vehicles.count == 0 { return nil }
            if vehicles.count == 1 { return .one(vehicle: vehicles.first!) }
            
            time: while true {
                for index in categorizedVehicels.indices {
                    if case var .stopParameters(stopNumber: stop, restDuration: restDuration, restInterval: restInterval) = categorizedVehicels[index].parameters {  // Наземный
                        if restDuration == 0 {  // Если транспорт едет
                            categorizedVehicels[index].coveredDistance += categorizedVehicels[index].vehicle.speed
                            restInterval -= 1
                            
                            if restInterval == 0 {
                                stop += 1  // Добавляем остановочку
                                
                                if case let .every(time) = (categorizedVehicels[index].vehicle as! GroundVehicle).restDuration {
                                    restDuration = time - 1
                                } else if case let .firstIsDifferent(first: first, remaining: remaining) = (categorizedVehicels[index].vehicle as! GroundVehicle).restDuration {
                                    restDuration = stop == 1 ? first - 1 : remaining - 1
                                } else if case let .theFirstTwoAreDifferent(first: first, second: second, remaining: remaining) = (categorizedVehicels[index].vehicle as! GroundVehicle).restDuration {
                                    restDuration = stop == 1 ? first - 1 : stop == 2 ? second - 1 : remaining - 1
                                }
                            }
                            
                            if categorizedVehicels[index].coveredDistance >= distance {
                                finishedVehicles.append(categorizedVehicels[index].vehicle)
                            }
                        } else {  // Если транспорт не едет
                            restDuration -= 1
                            
                            if restDuration == 0 {
                                restInterval = (categorizedVehicels[index].vehicle as! GroundVehicle).restInterval
                            }
                        }
                        
                        categorizedVehicels[index].parameters = .stopParameters(stopNumber: stop, restDuration: restDuration, restInterval: restInterval)
                    } else if case let .reducedDistance(distance) = categorizedVehicels[index].parameters {  // Воздушный
                        categorizedVehicels[index].coveredDistance += categorizedVehicels[index].vehicle.speed
                        
                        if categorizedVehicels[index].coveredDistance >= distance {
                            finishedVehicles.append(categorizedVehicels[index].vehicle)
                        }
                    }
                    
                    if finishedVehicles.count > 0 {
                        break time
                    }
                }
            }
            
            return .many(vehicles: finishedVehicles)
        }
        
        fileprivate func print() {
            for index in vehicles.indices {
                Swift.print("\(index): \(vehicles[index].name)")
            }
            Swift.print()
        }
        
        fileprivate func delete(vehicle: Vehicle) {
            guard let index = vehicles.firstIndex(where: { $0.name == vehicle.name }) else { return }
            vehicles.remove(at: index)
        }
    }
    
    class Vehicle {
        private(set) var name: String
        private(set) var speed: UInt
        fileprivate var type: VehiclesType?
        
        fileprivate init(name: String, speed: UInt) {
            self.name = name
            self.speed = speed
        }
    }
    
    final class GroundVehicle: Vehicle {
        private(set) var restInterval: UInt
        private(set) var restDuration: GroundVehicleStopType
        
        fileprivate init(name: String, speed: UInt, restInterval: UInt, restDuration: GroundVehicleStopType) {
            self.restInterval = restInterval
            self.restDuration = restDuration
            super.init(name: name, speed: speed)
            type = .ground
        }
    }
    
    final class AirVehicle: Vehicle {
        private(set) var distanceReduction: AirVehicleDistanceReducingType
        
        fileprivate init(name: String, speed: UInt, distanceReduction: AirVehicleDistanceReducingType) {
            self.distanceReduction = distanceReduction
            super.init(name: name, speed: speed)
            type = .air
        }
    }
}
