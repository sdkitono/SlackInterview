//
//  SlackUsersService.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 7/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation
import CoreData

//This class manages the slack users api and cache them to core data as necessary
class SlackUsersService {
    let apiToken = "xoxp-4698769766-4698769768-266771053075-66c3498cd17d3c736b94fdd14307ef20"
    var apiClient:SlackAPIClient
    var coreDataManager : CoreDataManager

    init(coreDataManager:CoreDataManager){
        self.apiClient = SlackAPIClient(apiToken: apiToken)
        self.coreDataManager = coreDataManager
    }
    
    func fetchAllUsers(completion:@escaping ()->()) {
        apiClient.send(GetSlackUsers(),SlackUsersResponse.self) { response in
            print("\nGetUsers finished:")
            switch response {
            case .success(let members):
                self.coreDataManager.updateUsersInDatabaseFromSlackUsers(slackUsers: members, completion: { (createdUsers, updatedUsers, deletedUsers) in
                    
                    // delete the image for deleted users
                    for member in deletedUsers {
                        self.deleteImageForUrl(urlString: member.profile?.image48)
                        self.deleteImageForUrl(urlString: member.profile?.image192)
                    }
                    
                    // delete the image for updated users
                    for member in updatedUsers {
                        self.deleteImageForUrl(urlString: member.profile?.image48)
                        self.deleteImageForUrl(urlString: member.profile?.image192)
                    }
                })
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // MARK: HELPER
    func deleteImageForUrl(urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        let url = URL(string: urlString)
        let fullPathString = FileHelper.fileInDocumentsDirectory(filename: url!.lastPathComponent)
        if FileManager.default.fileExists(atPath: fullPathString) {
            do{
                try FileManager.default.removeItem(atPath: fullPathString)
            } catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
}
