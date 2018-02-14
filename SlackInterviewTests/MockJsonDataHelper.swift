//
//  MockJsonDataHelper.swift
//  SlackInterviewTests
//
//  Created by Samuel Kitono on 13/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation

class MockJsonDataHelper {
    func createDataFromFile(fileString:String) -> Data{
        let path = Bundle(for: type(of: self)).path(forResource: fileString, ofType: "json")
        let contentString = try! String(contentsOfFile:path!, encoding: String.Encoding.utf8)
        return contentString.data(using: .utf8)!
    }
}
