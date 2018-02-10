import Foundation
import CoreData

class CoreDataStack {
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    var storeContainer: NSPersistentContainer

    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    init(storeContainer:NSPersistentContainer) {
        self.storeContainer = storeContainer
    }
    
    convenience init() {
        let container = NSPersistentContainer(name: "SlackInterview")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.init(storeContainer: container)
    }
}
