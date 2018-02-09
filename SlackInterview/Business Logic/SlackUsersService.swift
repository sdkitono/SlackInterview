//
//  SlackUsersService.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 7/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation
import CoreData

class SlackUsersService {
    let apiToken = "xoxp-4698769766-4698769768-266771053075-66c3498cd17d3c736b94fdd14307ef20"
    var apiClient:SlackAPIClient
    let coreDataManager = CoreDataManager.sharedInstance()
    init() {
        apiClient = SlackAPIClient(apiToken: apiToken)
    }
    
    func fetchAllUsers(completion:@escaping ()->()) {
        apiClient.send(GetSlackUsers(),SlackUsersResponse.self) { response in
            print("\nGetUsers finished:")
            switch response {
            case .success(let members):
                self.fetchUsersFromCoreData(completion: { (users, context) in
                    self.createNewUsersFrom(members: members, users: users, context: context)
                    self.updateUsersFrom(members: members, users: users, context: context)
                    self.deleteUsersFrom(members: members, users: users, context: context)
                })
                
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func populateUserWithSlackUser(user:User,slackUser:SlackUser) {
        user.id = slackUser.id!
        user.name = slackUser.name
        user.realName = slackUser.realName
        user.email = slackUser.profile?.email
        user.image192 = slackUser.profile?.image192
        user.image48 = slackUser.profile?.image48
        user.skype = slackUser.profile?.skype
        user.phone = slackUser.profile?.phone
        user.title = slackUser.profile?.title
        user.updatedTime = slackUser.updated!
    }
    
    func createNewUsersFrom(members:[SlackUser], users:[User], context:NSManagedObjectContext) {
        var createdMemberSet = Set(members.filter{ $0.deleted! == false }.map{ $0.id! })
        let usersSet = Set(users.map{ $0.id })
        createdMemberSet.subtract(usersSet)
        
        
        for member in members {
            if createdMemberSet.contains(member.id!) {
                let user = User(context: context)
                self.populateUserWithSlackUser(user: user, slackUser: member)
            }
        }
        try? context.save()
        
    }
    
    func deleteUsersFrom(members:[SlackUser], users:[User], context: NSManagedObjectContext) {
        let deletedMemberSet = Set(members.filter{ $0.deleted! == true }.map{ $0.id! })
        
        
        let userFetchRequest:NSFetchRequest = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "id IN %@", deletedMemberSet)
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
        
        try? context.save()
    }
    
    func updateUsersFrom(members:[SlackUser], users:[User], context:NSManagedObjectContext) {
        var slackUserDictionary:[String:SlackUser] = Dictionary()
        for member in members {
            slackUserDictionary[member.id!] = member
        }
        
        for user in users {
            if let member = slackUserDictionary[user.id] {
                if member.updated! > user.updatedTime {
                    self.populateUserWithSlackUser(user: user, slackUser: member)
                }
            }
        }
        
        try? context.save()
        
    }
    
    func fetchUsersFromCoreData(completion:@escaping ([User], NSManagedObjectContext) -> ()) {
        coreDataManager.coreDataStack.storeContainer.performBackgroundTask { (context) in
            do {
                let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
                let results = try context.fetch(fetchRequest)
                completion(results, context)
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    
}
