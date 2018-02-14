//
//  UnitTestHelper.swift
//  SlackInterviewTests
//
//  Created by Samuel Kitono on 13/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import XCTest
import CoreData
@testable import SlackInterview




//MARK: HELPER
func testAssertCellViewModelWithSlackUser(slackUserCellViewModel:SlackUserCellViewModel,slackUser:SlackUser){
    XCTAssert(slackUserCellViewModel.realNameText == slackUser.realName)
    XCTAssert(slackUserCellViewModel.userNameText == slackUser.name)
    XCTAssert(slackUserCellViewModel.userImageUrlString == slackUser.profile?.image48)
}

func testAssertDetailViewModelWithSlackUser(userDetailViewModel:SlackUsersDetailViewModel,slackUser:SlackUser){
    XCTAssert(userDetailViewModel.emailText == slackUser.profile?.email)
    XCTAssert(userDetailViewModel.skypeText == slackUser.profile?.skype)
    XCTAssert(userDetailViewModel.phoneText == slackUser.profile?.phone)
    XCTAssert(userDetailViewModel.realNameText == slackUser.realName)
    XCTAssert(userDetailViewModel.userNameText == slackUser.name)
    XCTAssert(userDetailViewModel.userImageUrlString == slackUser.profile?.image192)
    XCTAssert(userDetailViewModel.titleText == slackUser.profile?.title)
}

func testAssertUserWithSlackUser(user:User,slackUser:SlackUser){
    XCTAssert(user.id == slackUser.id)
    XCTAssert(user.name == slackUser.name)
    XCTAssert(user.realName == slackUser.realName)
    XCTAssert(user.email == slackUser.profile?.email)
    XCTAssert(user.skype == slackUser.profile?.skype)
    XCTAssert(user.phone == slackUser.profile?.phone)
    XCTAssert(user.title == slackUser.profile?.title)
    XCTAssert(user.updatedTime == slackUser.updated!)
    XCTAssert(user.image192 == slackUser.profile?.image192)
    XCTAssert(user.image48 == slackUser.profile?.image48)
}

func getSlackResponseFromData(data:Data) -> SlackUsersResponse {
    let slackResponse = try! JSONDecoder().decode(SlackUsersResponse.self, from: data)
    return slackResponse
}

func deleteAllUsers(coreDataManager:CoreDataManager) {
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    let context = coreDataManager.coreDataStack.managedContext
    let objs = try! context.fetch(fetchRequest)
    for case let obj as NSManagedObject in objs {
        context.delete(obj)
    }
    
    coreDataManager.saveContext()
}
