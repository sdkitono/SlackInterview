//
//  SlacUsersFetchControllerFactory.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 7/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import CoreData

class SlackUsersFetchControllerFactory {
    static func slackUsersFetchedResultsController() ->NSFetchedResultsController<User> {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(User.realName), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.sharedInstance().coreDataStack.storeContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }
}
