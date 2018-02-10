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
    
    var coreDataStack:CoreDataStack
    
    func saveContext() {
        coreDataStack.saveContext()
    }
    
    init(coreDataStack:CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    convenience init() {
        self.init(coreDataStack: CoreDataStack())
    }

    func fetchUsersFromCoreData(completion:@escaping ([User], NSManagedObjectContext) -> ()) {
        coreDataStack.storeContainer.performBackgroundTask { (context) in
            do {
                let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
                let results = try context.fetch(fetchRequest)
                completion(results, context)
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func populateUserWithSlackUser(user:User,slackUser:SlackUser) {
        user.id = slackUser.id!
        user.name = slackUser.name
        user.realName = slackUser.realName
        user.email = slackUser.profile?.email
        
        user.skype = slackUser.profile?.skype
        user.phone = slackUser.profile?.phone
        user.title = slackUser.profile?.title
        user.updatedTime = slackUser.updated!
        user.image192 = slackUser.profile?.image192
        user.image48 = slackUser.profile?.image48
    }
    
    func createNewUsersFrom(members:[SlackUser], users:[User], createdUsers: inout [SlackUser], context:NSManagedObjectContext) {
        var createdMemberSet = Set(members.filter{ $0.deleted! == false }.map{ $0.id! })
        let usersSet = Set(users.map{ $0.id })
        createdMemberSet.subtract(usersSet)
        
        for member in members {
            if createdMemberSet.contains(member.id!) {
                createdUsers.append(member)
                let user = User(context: context)
                self.populateUserWithSlackUser(user: user, slackUser: member)
            }
        }
        try? context.save()
    }
    
    func deleteUsersFrom(members:[SlackUser], users:[User], deletedUsers: inout [SlackUser], context: NSManagedObjectContext) {
        let deletedMemberSet = Set(members.filter{ $0.deleted! == true }.map{ $0.id! })
        
        guard deletedMemberSet.count > 0 else {
            return
        }
        

        
        let userFetchRequest:NSFetchRequest = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "id IN %@", argumentArray: Array(deletedMemberSet))
        
        
        
        //Here is an implementation using batch delete, Would have used this but because for unit testing, this is not supported for in memory store so i have to use the alternate (old) solution
        /*
         let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: userFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
         
         // Configure Batch Update Request
         batchDeleteRequest.resultType = .resultTypeCount
         
         do {
         // Execute Batch Request
         let batchDeleteResult = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
         print("The batch delete request has deleted \(batchDeleteResult.result!) records.")
         
         } catch {
         let updateError = error as NSError
         print("\(updateError), \(updateError.userInfo)")
         }
         */
        
        do {
            let usersDeleted = try context.fetch(userFetchRequest)
            for user in usersDeleted {
                context.delete(user)
            }
            
            // Add deleted users
            deletedUsers.append(contentsOf: members.filter {deletedMemberSet.contains($0.id!)})
        } catch {
            let deleteError = error as NSError
            print("\(deleteError), \(deleteError.userInfo)")
        }
        
        try? context.save()
    }
    
    func updateUsersFrom(members:[SlackUser], users:[User], updatedUsers: inout [SlackUser], context:NSManagedObjectContext) {
        var slackUserDictionary:[String:SlackUser] = Dictionary()
        for member in members {
            slackUserDictionary[member.id!] = member
        }
        
        for user in users {
            if let member = slackUserDictionary[user.id] {
                if member.updated! > user.updatedTime {
                    updatedUsers.append(member)
                    self.populateUserWithSlackUser(user: user, slackUser: member)
                }
            }
        }
        
        try? context.save()
        
    }
    
    func updateUsersInDatabaseFromSlackUsers(slackUsers:[SlackUser],completion:@escaping (_ createdUsers:[SlackUser], _ updatedUsers:[SlackUser], _ deletedUsers:[SlackUser]) ->()) {
        self.fetchUsersFromCoreData { (users, context) in
            
            var createdUsers:[SlackUser] = []
            var deletedUsers:[SlackUser] = []
            var updatedUsers:[SlackUser] = []
            
            self.createNewUsersFrom(members: slackUsers, users: users,createdUsers: &createdUsers , context: context)
            self.updateUsersFrom(members: slackUsers, users: users,updatedUsers: &updatedUsers, context: context)
            self.deleteUsersFrom(members: slackUsers, users: users,deletedUsers: &deletedUsers, context: context)
            
            completion(createdUsers,updatedUsers,deletedUsers)
        }
    }
}

