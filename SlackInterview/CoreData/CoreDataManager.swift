//
//  CoreDataManager.swift
//  RoverInterview
//
//  Created by Samuel Kitono on 27/1/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    class func sharedInstance() -> CoreDataManager {
        struct __ { static let _sharedInstance = CoreDataManager() }
        return __._sharedInstance
    }
    
    
    lazy var coreDataStack:CoreDataStack = CoreDataStack()
    
    
    /*
    func countDogs() -> Int {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Dog")
        fetchRequest.resultType = .countResultType
        do {
            let countResult = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            let count = countResult.first!.intValue
            return count
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
        }
        
        return 0
    }
    
    func createDogEntity() -> Dog {
        return coreDataStack.createRecordForEntity("Dog") as! Dog
    }
    
    func deleteAllDogs() {
        let fetchRequest:NSFetchRequest<Dog> = Dog.fetchRequest()
        fetchRequest.includesPropertyValues = false
        do {
            let dogs = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            for result in dogs{
                coreDataStack.managedObjectContext.delete(result)
            }
        } catch let error as NSError {
            print("Delete all dogs \(error), \(error.userInfo)")
        }
    }
 */
    
    
    
    func createUser(slackUser:SlackUser) {
        
        
        
        
    }
    
    
    
    func saveContext() {
        /*
        do{
            try coreDataStack.saveContext()
        } catch let error as NSError {
            print("Saving context error \(error), \(error.userInfo)")
            throw error
        }
 */
        
        coreDataStack.saveContext()
    }
    
}

