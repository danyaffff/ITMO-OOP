//
//  Backup.swift
//  Backup
//
//  Created by Даниил Храповицкий on 01.11.2020.
//

import Foundation
//TODO: переделать 146 строка

/**
 The centralized point of control and coordination of Backups.
 
 The Backup class provides a programmatic interface for interacting with the backup system. The backup system allows an app to create a backups and restore files from backups. For example, you can create a backup of a file, modify the file and return it to the state it was in when the restore point was created.
 
 - Warning: This class does not provide real capability for file restoring.
 - Important: Memory is measured in KB.
*/
final class Backup: CustomStringConvertible {
    
    //MARK: Properties
    /// Returns the singleton backup instance.
    static var shared = Backup()
    
    /// Returns the files that will be in the restore point.
    private(set) var files: [FileModel] = []
    
    /// Formats the date when the restore point was added.
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    /// Returns the entire size of restore points.
    private var entireSize: CGFloat {
        get {
            var size: CGFloat = 0
            
            for restorePoint in restorePoints {
                size += restorePoint.size
            }
            
            return (size * 100).rounded() / 100
        }
    }
    
    /// Conditions for removing restore points.
    private var removalConditions: FilteredType = .none
    
    /// Created restore points.
    private(set) var restorePoints: [RestorePointModel] = []
    
    //MARK: - Initialization
    /// Private Backup initializator.
    private init() {}
    
    //MARK: - Public methods
    /// Creates a new restore point.
    func createRestorePoint(ofType type: RestorePointInstanceType) {
        switch type {
        case .full:
            var pointSize: CGFloat = 0
            
            for file in files {
                pointSize += (file.size * 100).rounded() / 100
            }
            
            restorePoints.append(RestorePointModel(files: files, size: pointSize, date: Date(), type: .full))
        case .increment:
            var changedFiles: [FileModel] = []
            var changesSize: CGFloat = 0
            
            for file in files {
                let url = URL(fileURLWithPath: file.name)
                
                if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path), let size = attributes[.size] as? CGFloat {
                    let newSize = ((size / 1024) * 100).rounded() / 100
                    let sizeOfUpdates = abs((file.size * 100).rounded() / 100 - newSize)
                    
                    if sizeOfUpdates != 0 {
                        changedFiles.append(FileModel(name: file.name, size: sizeOfUpdates))
                        changesSize += sizeOfUpdates
                    }
                }
            }
            
            restorePoints.append(RestorePointModel(files: changedFiles, size: changesSize, date: Date(), type: .increment))
        }
        
        files.removeAll()
    }
    
    /// Removes restore point.
    func removeRestorePoint(_ point: RestorePointModel) {
        guard let index = restorePoints.firstIndex(where: { $0 == point }) else { return }
        restorePoints.remove(at: index)
    }
    
    /// Sets conditions for deleting restore points.
    func setFilterForRemoving(condition: FilteredType) {
        removalConditions = condition
    }
    
    /// Updates the model according to the remove conditions.
    func update() {
        switch removalConditions {
        case .none:
            break
        case .quantity(let amount):
            let _ = checkQuantity(amount: amount)
        case.date(let date):
            let _ = checkDate(date: date)
        case .size(let size):
            let _ = checkSize(size: size)
        case .one(let conditions):
            for condition in conditions {
                switch condition {
                case .quantity(let amount):
                    let _ = checkQuantity(amount: amount)
                case .date(let date):
                    let _ = checkDate(date: date)
                case .size(let size):
                    let _ = checkSize(size: size)
                default:
                    break
                }
            }
        case .some(let conditions):
            var preparedForRemoval: [[RestorePointModel]] = []
            
            for condition in conditions {
                switch condition {
                case .quantity(let amount):
                    preparedForRemoval.append(checkQuantity(amount: amount, isNecessary: false)!)
                case .date(let date):
                    preparedForRemoval.append(checkDate(date: date, isNecessary: false)!)
                case .size(let size):
                    preparedForRemoval.append(checkSize(size: size, isNecessary: false)!)
                default:
                    break
                }
            }
            
            var removableElementsIndices: [Int] = []
            
            for index in restorePoints.indices {
                if let firstIndex = preparedForRemoval[preparedForRemoval.count - 1].firstIndex(where: { $0 == restorePoints[index] }) {  // Элементы при сравнении неотличимы
                    if preparedForRemoval.count - 2 >= 0 {
                        if let secondIndex = preparedForRemoval[preparedForRemoval.count - 2].firstIndex(where: { $0 == restorePoints[index] }) {
                            if preparedForRemoval.count - 3 >= 0 {
                                if let thirdIndex = preparedForRemoval[preparedForRemoval.count - 3].firstIndex(where: { $0 == restorePoints[index] }) {
                                    preparedForRemoval[preparedForRemoval.count - 1].remove(at: firstIndex)
                                    preparedForRemoval[preparedForRemoval.count - 2].remove(at: secondIndex)
                                    preparedForRemoval[preparedForRemoval.count - 3].remove(at: thirdIndex)
                                    removableElementsIndices.append(index)
                                }
                            } else {
                                preparedForRemoval[preparedForRemoval.count - 1].remove(at: firstIndex)
                                preparedForRemoval[preparedForRemoval.count - 2].remove(at: secondIndex)
                                removableElementsIndices.append(index)
                            }
                        }
                    } else {
                        preparedForRemoval[preparedForRemoval.count - 1].remove(at: firstIndex)
                        removableElementsIndices.append(index)
                    }
                }
            }
            
            for index in removableElementsIndices.indices {
                restorePoints.remove(at: removableElementsIndices[index] - index)
            }
        }
    }
    
    /// Adds local file or folder to Backup.
    func add(_ element: FileType) {
        switch element {
        case .file(let name):
            addFile(withName: name)
        case .folder(let name):
            addFolder(withName: name)
        }
    }
    
    /// Removes file from backup.
    func removeFile(_ file: FileModel) {
        guard let index = files.firstIndex(where: { $0.name == file.name }) else { return }
        files.remove(at: index)
    }
    
    //MARK: - Private methods
    
    /// Adds local file to Backup.
    private func addFile(withName name: String) {
        let url = URL(fileURLWithPath: name)
        
        if FileManager.default.fileExists(atPath: url.path) {
            let attributes = try! FileManager.default.attributesOfItem(atPath: url.path)
            
            if let size = attributes[.size] as? CGFloat {
                files.append(FileModel(name: name, size: size / 1024))
            }
        }
    }
    
    /// Adds local folder to Backup.
    private func addFolder(withName name: String) {
        let url = URL(string: FileManager.default.currentDirectoryPath)!.appendingPathComponent(name)
        
        if FileManager.default.directoryExists(atPath: url.path) {
            let urls = try! FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            
            for url in urls {
                let attributes = try! FileManager.default.attributesOfItem(atPath: url.path)
                
                if let size = attributes[.size] as? CGFloat {
                    files.append(FileModel(name: url.pathComponents[url.pathComponents.count - 2] + "/" + url.lastPathComponent, size: size / 1024))
                }
            }
        }
    }
    
    /// Checks the quantity conformity.
    private func checkQuantity(amount: Int, isNecessary: Bool = true) -> [RestorePointModel]? {
        if isNecessary {
            let difference = restorePoints.count - amount
            
            if difference > 0 {
                for _ in 0 ..< difference {
                    restorePoints.remove(at: restorePoints.startIndex)
                }
            }
            return nil
        } else {
            var returned: [RestorePointModel] = []
            let difference = restorePoints.count - amount
            
            if difference > 0 {
                for _ in 0 ..< difference {
                    returned.append(restorePoints[difference])
                }
            }
            
            return returned
        }
    }
    
    /// Checks the date conformity.
    private func checkDate(date: Date, isNecessary: Bool = true) -> [RestorePointModel]? {
        if isNecessary {
            for index in restorePoints.indices {
                if date > restorePoints[index].date {
                    restorePoints.remove(at: index)
                }
            }
            return nil
        } else {
            var returned: [RestorePointModel] = []
            
            for index in restorePoints.indices {
                if date > restorePoints[index].date {
                    returned.append(restorePoints[index])
                }
            }
            
            return returned
        }
    }
    
    /// Checks the size confirmity.
    private func checkSize(size: CGFloat, isNecessary: Bool = true) -> [RestorePointModel]? {
        if isNecessary {
            while entireSize > size {
                restorePoints.remove(at: restorePoints.startIndex)
            }
            return nil
        } else {
            var returned: [RestorePointModel] = []
            
            for index in restorePoints.indices {
                var entireSize: CGFloat = 0
                
                for checked in index ..< restorePoints.count {
                    entireSize += restorePoints[checked].size
                }
                
                if entireSize > size {
                    returned.append(restorePoints[index])
                } else {
                    break
                }
            }
            
            return returned
        }
    }
    
    //MARK: - Class description
    var description: String {
        var returned: [String] = ["\(restorePoints.count) restore point\(restorePoints.count == 1 ? "" : ""), \(entireSize) KB:"]
        
        for index in restorePoints.indices {
            returned.append("\(index + 1). \(formatter.string(from: restorePoints[index].date)), \((restorePoints[index].size * 100).rounded() / 100) KB — \(restorePoints[index].type == .full ? "Full" : "Increment")\n\(restorePoints[index])")
        }
        
        returned.append("\n")
        
        return returned.joined(separator: "\n")
    }
}
