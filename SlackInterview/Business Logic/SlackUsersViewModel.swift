//
//  SlackUsersViewModel.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 12/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation
import CoreData

enum SlackUsersChangedEvent {
    case beginUpdate
    case endUpdate
    case insert(indexPath:IndexPath)
    case delete(indexPath:IndexPath)
    case update(indexPath:IndexPath)
    case move(indexPath:IndexPath, newIndexPath:IndexPath)
    
}

class SlackUsersViewModel : NSObject {
    var fetchedResultsController: NSFetchedResultsController<User>
    var slackUsersService:SlackUsersService
    var slackUserCellViewModels:[SlackUserCellViewModel] = []
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var numberOfSections:Int {
        get {
            guard let sections = fetchedResultsController.sections else {
                return 0
            }
            return sections.count
        }
    }
    
    var numberOfRows:Int {
        get {
            guard let sectionInfo = fetchedResultsController.sections?[0] else {
                return 0
            }
            return sectionInfo.numberOfObjects
        }
    }
    
    
    var updateLoadingStatus: (()->())?
    var slackUsersChanged: ((SlackUsersChangedEvent)->())?
    
  
    init(coreDataManager:CoreDataManager, slackUsersService: SlackUsersService) {
        fetchedResultsController = SlackUsersFetchControllerFactory.slackUsersFetchedResultsController(context: coreDataManager.coreDataStack.storeContainer.viewContext)
        self.slackUsersService = slackUsersService
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    func fetchUsers(completion:(() -> ())?) {
        isLoading = true
        slackUsersService.fetchAllUsers{
            DispatchQueue.main.async {
                self.isLoading = false
                completion?()
            }
        }
    }
    
    func getUserDetailViewModelForIndexPath(indexPath:IndexPath) -> SlackUsersDetailViewModel {
        let user:User = fetchedResultsController.object(at: indexPath)
        return SlackUsersDetailViewModel(userNameText: user.name!, realNameText: user.realName!, emailText: user.email!, skypeText: user.skype!, phoneText: user.phone!, titleText: user.title!, userImageUrlString: user.image192!)
    }
    
    func getSlackUserCellViewModelForIndex(indexPath:IndexPath) -> SlackUserCellViewModel {
        let user = fetchedResultsController.object(at: indexPath)
        return createUserCellViewModelFromUser(user: user)
    }
    
    func createUserCellViewModelFromUser(user:User) -> SlackUserCellViewModel {
        return SlackUserCellViewModel(userNameText: user.name!, realNameText: user.realName!, userImageUrlString: user.image48!)
    }
}

extension SlackUsersViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        slackUsersChanged?(.beginUpdate)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .insert:
                self.slackUsersChanged?(.insert(indexPath: newIndexPath!))
            case .delete:
                self.slackUsersChanged?(.delete(indexPath: indexPath!))
            case .update:
                self.slackUsersChanged?(.update(indexPath: indexPath!))
            case .move:
                self.slackUsersChanged?(.move(indexPath: indexPath!, newIndexPath: newIndexPath!))
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        slackUsersChanged?(.endUpdate)
    }
}

struct SlackUserCellViewModel {
    let userNameText: String
    let realNameText: String
    let userImageUrlString: String
}

struct SlackUsersDetailViewModel {
    let userNameText: String
    let realNameText: String
    let emailText: String
    let skypeText: String
    let phoneText: String
    let titleText: String
    let userImageUrlString: String
}
