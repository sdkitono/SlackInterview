//
//  SlackInterviewTests.swift
//  SlackInterviewTests
//
//  Created by Samuel Kitono on 6/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import XCTest
import CoreData
@testable import SlackInterview

class SlackInterviewTests: XCTestCase {
    
    
    var mockCoreData = MockCoreData()
    let mockSession = MockURLSession()
    var coreDataManager = CoreDataManager()
    var slackUsersService : SlackUsersService!
    var fetchedResultsController: NSFetchedResultsController<User>!
    
    override func setUp() {
        super.setUp()
    
        // We use mock persistent container so we use in memory database now
        coreDataManager.coreDataStack.storeContainer = mockCoreData.mockPersistentContainer
        
        slackUsersService = SlackUsersService(coreDataManager:coreDataManager)
        
        // We mock the url session to mock the returned data from network
        slackUsersService.apiClient.session = mockSession
        
        fetchedResultsController = SlackUsersFetchControllerFactory.slackUsersFetchedResultsController(context: mockCoreData.mockPersistentContainer.viewContext)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sleep(2)
        deleteAllUsers()
        
        super.tearDown()
    }
    
    func testCreateUsers() {

        let createUsersExpectation = expectation(description: "Create users")
        
        // We have a mock data json from network
        let createData = createDataFromFile(fileString: "createData")
        let slackUsersResponse = getSlackResponseFromData(data: createData)
        mockSession.nextData = createData
        
        slackUsersService.fetchAllUsers {
            
            // We sleep for 1 second to wait for core data finish processing at the background
            sleep(1)
            try! self.fetchedResultsController.performFetch()
            let users:[User] = self.fetchedResultsController.fetchedObjects!
            XCTAssert(users.count == 3)
            
            for i in 0..<users.count {
                let user = users[i]
                self.testAssertUserWithSlackUser(user: user, slackUser: slackUsersResponse.members![i])
            }
            
            createUsersExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreateAndThenDeleteUsers() {
        
        let createUsersAndDeleteExpectation = expectation(description: "Create users then delete")
        
        // We have a mock data json from network
        let createData = createDataFromFile(fileString: "createNewData")
        let slackUsersResponse = getSlackResponseFromData(data: createData)
        
        // we have mock data where a user is deleted
        let deleteData = createDataFromFile(fileString: "deleteData")
        
        var deletedMembers = slackUsersResponse.members!
        deletedMembers.remove(at: 1)
        
        mockSession.nextData = createData
        slackUsersService.fetchAllUsers {
            // We sleep for 1 second to wait for core data finish processing at the background
            sleep(1)
            self.mockSession.nextData = deleteData
            
            self.slackUsersService.fetchAllUsers {
                // We sleep for 1 second to wait for core data finish processing at the background
                sleep(1)
                try! self.fetchedResultsController.performFetch()
                let users:[User] = self.fetchedResultsController.fetchedObjects!
                XCTAssert(users.count == 2)
                
                for i in 0..<users.count {
                    let user = users[i]
                    self.testAssertUserWithSlackUser(user: user, slackUser: deletedMembers[i])
                }
                
                createUsersAndDeleteExpectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreateAndThenUpdateUsers() {
        
        let createUsersAndDeleteExpectation = expectation(description: "Create users then delete")
        
        // We have a mock data json from network
        let createData = createDataFromFile(fileString: "createNewData")
        
        // Mock data with updated user
        let updateData = createDataFromFile(fileString: "updateData")
        let slackUpdatedUsersResponse = getSlackResponseFromData(data: updateData)
        
        mockSession.nextData = createData
        slackUsersService.fetchAllUsers {
            // We sleep for 1 second to wait for core data finish processing at the background
            sleep(1)
            
            // Next fetch will be the with the updated user
            self.mockSession.nextData = updateData
            
            self.slackUsersService.fetchAllUsers {
                // We sleep for 1 second to wait for core data finish processing at the background
                sleep(1)
                try! self.fetchedResultsController.performFetch()
                let users:[User] = self.fetchedResultsController.fetchedObjects!
                XCTAssert(users.count == 3)
                
                // Test core data against updated data
                for i in 0..<users.count {
                    let user = users[i]
                    self.testAssertUserWithSlackUser(user: user, slackUser: slackUpdatedUsersResponse.members![i])
                }
                
                
                createUsersAndDeleteExpectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    //MARK: HELPER
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
    
    func createDataFromFile(fileString:String) -> Data{
        let path = Bundle(for: type(of: self)).path(forResource: fileString, ofType: "json")
        let contentString = try! String(contentsOfFile:path!, encoding: String.Encoding.utf8)
        return contentString.data(using: .utf8)!
    }
    
    func deleteAllUsers() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let context = coreDataManager.coreDataStack.managedContext
        let objs = try! context.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            context.delete(obj)
        }
        
        coreDataManager.saveContext()
    }
    
}
