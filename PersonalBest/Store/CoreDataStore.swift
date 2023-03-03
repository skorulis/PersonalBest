//Created by Alexander Skorulis on 3/10/2022.

import CoreData

struct CoreDataStore {

    let container: NSPersistentCloudKitContainer
    
    static func previews() -> CoreDataStore {
        let p = self.init(inMemory: true)
        return p
    }
    
    static func database() -> CoreDataStore {
        let p = self.init(inMemory: false)
        return p
    }

    init(inMemory: Bool) {
        container = NSPersistentCloudKitContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    var childMainContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = mainContext
        return context
    }
}
