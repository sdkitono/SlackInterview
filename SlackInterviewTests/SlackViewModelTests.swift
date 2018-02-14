//
//  SlackViewModelTests.swift
//  SlackInterviewTests
//
//  Created by Samuel Kitono on 13/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import XCTest
import CoreData
@testable import SlackInterview

class SlackViewModelTests: XCTestCase {
    var mockCoreData = MockCoreData()
    let mockSession = MockURLSession()
    var coreDataManager = CoreDataManager()
    var slackUsersService : SlackUsersService!
    var slackUsersViewModel: SlackUsersViewModel!
    let mockJsonDataHelper = MockJsonDataHelper()
    
    override func setUp() {
        super.setUp()
        
        // We use mock persistent container so we use in memory database now
        coreDataManager.coreDataStack.storeContainer = mockCoreData.mockPersistentContainer
        slackUsersService = SlackUsersService(coreDataManager:coreDataManager)
        
        // We mock the url session to mock the returned data from network
        slackUsersService.apiClient.session = mockSession
        
        slackUsersViewModel = SlackUsersViewModel(coreDataManager:coreDataManager, slackUsersService: slackUsersService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sleep(1)
        deleteAllUsers(coreDataManager: coreDataManager)
        
        super.tearDown()
    }
    
    
    //MARK: Test Slack User View Model
    func testCreateUsersForViewModel() {
        let createUsersExpectation = expectation(description: "Create users view model")
        
        // We have a mock data json from network
        let createData = mockJsonDataHelper.createDataFromFile(fileString: "createData")
        let slackUsersResponse = getSlackResponseFromData(data: createData)
        mockSession.nextData = createData
        
        
        slackUsersViewModel.fetchUsers {
            // Wait for core data to finish processing
            sleep(1)
            
            try! self.slackUsersViewModel.fetchedResultsController.performFetch()
            
            XCTAssert(self.slackUsersViewModel.numberOfSections == 1)
            XCTAssert(self.slackUsersViewModel.numberOfRows == 3)
            
            for i in 0..<self.slackUsersViewModel.numberOfRows {
                let cellViewModel = self.slackUsersViewModel.getSlackUserCellViewModelForIndex(indexPath: IndexPath(row: i, section: 0))
                let detailViewModel = self.slackUsersViewModel.getUserDetailViewModelForIndexPath(indexPath: IndexPath(row: i, section: 0))
                testAssertCellViewModelWithSlackUser(slackUserCellViewModel: cellViewModel, slackUser: slackUsersResponse.members![i])
                testAssertDetailViewModelWithSlackUser(userDetailViewModel: detailViewModel, slackUser: slackUsersResponse.members![i])
            }
            
            createUsersExpectation.fulfill()
        }
        
        
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreateUsersAndDeleteForViewModel() {
        let deleteUsersExpectation = expectation(description: "Create users and delete view model")
        
        // We have a mock data json from network
        let createData = mockJsonDataHelper.createDataFromFile(fileString: "createData")
        
        mockSession.nextData = createData
        
        // we have mock data where a user is deleted
        let deleteData = mockJsonDataHelper.createDataFromFile(fileString: "deleteData")
        let slackUsersResponse = getSlackResponseFromData(data: deleteData)
        var deletedMembers = slackUsersResponse.members!
        deletedMembers.remove(at: 1)
        
        slackUsersViewModel.fetchUsers {
            // Wait for core data to finish processing
            sleep(1)
            
            try! self.slackUsersViewModel.fetchedResultsController.performFetch()
            
            XCTAssert(self.slackUsersViewModel.numberOfSections == 1)
            XCTAssert(self.slackUsersViewModel.numberOfRows == 3)
            
            self.mockSession.nextData = deleteData
            
            self.slackUsersViewModel.fetchUsers {
                // Wait for core data to finish processing
                sleep(1)
                try! self.slackUsersViewModel.fetchedResultsController.performFetch()
                
                // Assert now there are 2 viewmodels only
                XCTAssert(self.slackUsersViewModel.numberOfSections == 1)
                XCTAssert(self.slackUsersViewModel.numberOfRows == 2)
                
                for i in 0..<self.slackUsersViewModel.numberOfRows {
                    let cellViewModel = self.slackUsersViewModel.getSlackUserCellViewModelForIndex(indexPath: IndexPath(row: i, section: 0))
                    let detailViewModel = self.slackUsersViewModel.getUserDetailViewModelForIndexPath(indexPath: IndexPath(row: i, section: 0))
                    testAssertCellViewModelWithSlackUser(slackUserCellViewModel: cellViewModel, slackUser: deletedMembers[i])
                    testAssertDetailViewModelWithSlackUser(userDetailViewModel: detailViewModel, slackUser: deletedMembers[i])
                }
                
                deleteUsersExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreateUsersAndUpdateForViewModel() {
        let deleteUsersExpectation = expectation(description: "Create users and delete view model")
        
        // We have a mock data json from network
        let createData = mockJsonDataHelper.createDataFromFile(fileString: "createData")
        mockSession.nextData = createData
        
        // Mock data with updated user
        let updateData = mockJsonDataHelper.createDataFromFile(fileString: "updateData")
        let slackUpdatedUsersResponse = getSlackResponseFromData(data: updateData)
        
        slackUsersViewModel.fetchUsers {
            // Wait for core data to finish processing
            sleep(1)
            
            try! self.slackUsersViewModel.fetchedResultsController.performFetch()
            
            XCTAssert(self.slackUsersViewModel.numberOfSections == 1)
            XCTAssert(self.slackUsersViewModel.numberOfRows == 3)
            
            self.mockSession.nextData = updateData
            
            self.slackUsersViewModel.fetchUsers {
                // Wait for core data to finish processing
                sleep(1)
                try! self.slackUsersViewModel.fetchedResultsController.performFetch()
                
                // Still 3 view models
                XCTAssert(self.slackUsersViewModel.numberOfSections == 1)
                XCTAssert(self.slackUsersViewModel.numberOfRows == 3)
                
                for i in 0..<self.slackUsersViewModel.numberOfRows {
                    let cellViewModel = self.slackUsersViewModel.getSlackUserCellViewModelForIndex(indexPath: IndexPath(row: i, section: 0))
                    let detailViewModel = self.slackUsersViewModel.getUserDetailViewModelForIndexPath(indexPath: IndexPath(row: i, section: 0))
                    testAssertCellViewModelWithSlackUser(slackUserCellViewModel: cellViewModel, slackUser: slackUpdatedUsersResponse.members![i])
                    testAssertDetailViewModelWithSlackUser(userDetailViewModel: detailViewModel, slackUser: slackUpdatedUsersResponse.members![i])
                }
                
                deleteUsersExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
}
