//
//  GetSlackUsers.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 6/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation

public struct GetSlackUsers: APIRequest {
    public typealias Response = [SlackUser]
    
    public var resourceName: String {
        return "users.list"
    }
}
