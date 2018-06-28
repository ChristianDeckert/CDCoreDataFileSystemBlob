import Foundation
import CoreData

extension URL {
    var path: String {
        return absoluteString.replacingOccurrences(of: "file://", with: "")
    }
}

struct CDCoreDataFileSystemBlob {
    
    static var pattern: String { return "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" }
    
    static func extractUUID(from objectId: NSManagedObjectID) -> String {
        
        let id = objectId.uriRepresentation().absoluteString
        do {
            let regex = try NSRegularExpression(pattern: pattern,
                                                options: NSRegularExpression.Options.caseInsensitive)
            if let uuid = regex.firstMatch(in: id, options: .reportCompletion,
                                           range: NSRange(location: 0, length: id.count)),
                let range: Range = Range.init(uuid.range, in: id) {
                return String(id[range])
            }
        } catch {
            debugPrint("CDCoreDataFileSystemBlob: \(error.localizedDescription)")
        }
        return objectId.uriRepresentation().absoluteString
    }
    
    static var imageStoreDirectoryUrl: URL {
        return documentsDirUrl.appendingPathComponent("CDCoreDataFileSystemBlob", isDirectory: true)
    }
    
    static var documentsDirUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private static func directoryUrl(for uuid: String, pId: String) -> URL {
        return imageStoreDirectoryUrl
            .appendingPathComponent(uuid, isDirectory: true)
            .appendingPathComponent(pId, isDirectory: true)
    }
    
    private static func storeUrl(for key: String, uuid: String, pId: String) -> URL {
        return directoryUrl(for: uuid, pId: pId).appendingPathComponent(key, isDirectory: false)
    }
    
    @discardableResult
    static func store(data: Data, for key: String, uuid: String, pId: String) -> Bool {
        do {
            let dirPath = directoryUrl(for: uuid, pId: pId).path
            
            if !FileManager.default.fileExists(atPath: dirPath) {
                try FileManager.default.createDirectory(atPath: dirPath,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            }

            return FileManager.default.createFile(atPath: storeUrl(for: key, uuid: uuid, pId: pId).path,
                                                  contents: data,
                                                  attributes: nil)
        } catch {
            return false
        }
    }
    
    static func data(for key: String, uuid: String, pId: String) -> Data? {
        let path = storeUrl(for: key, uuid: uuid, pId: pId).path
        return FileManager.default.contents(atPath: path)
    }
    
    @discardableResult
    static func delete(for key: String, uuid: String, pId: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: storeUrl(for: key, uuid: uuid, pId: pId).path)
            return true
        } catch {
            return false
        }
    }
    @discardableResult
    static func deleteAll(uuid: String, pId: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: directoryUrl(for: uuid, pId: pId).path)
            return true
        } catch {
            return false
        }
    }
    
    static func reset() -> Bool {
        do {
            try FileManager.default.removeItem(atPath: imageStoreDirectoryUrl.absoluteString)
            return true
        } catch {
            return false
        }
    }

}

extension NSManagedObjectID {
    var uuidString: String {
        return CDCoreDataFileSystemBlob.extractUUID(from: self)
    }
}

extension NSManagedObject {

    var objectUUID: String {
        return objectID.uuidString
    }
    
    var pId: String {
        return (objectID.uriRepresentation().absoluteString as NSString).lastPathComponent
    }
    
    @discardableResult func store(data: Data, for key: String) -> Bool {
        return CDCoreDataFileSystemBlob.store(data: data, for: key, uuid: objectUUID, pId: pId)
    }
    
    func data(for key: String) -> Data? {
        return CDCoreDataFileSystemBlob.data(for: key, uuid: objectUUID, pId: pId)
    }
    
    func deleteData(for key: String) {
        CDCoreDataFileSystemBlob.delete(for: key, uuid: objectUUID, pId: pId)
    }
    
    func deleteAllData() {
        CDCoreDataFileSystemBlob.deleteAll(uuid: objectUUID, pId: pId)
    }
    
}
