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
        
    // Parameters
    public let name: String?
    public let nameStartsWith: String?
    public let limit: Int?
    public let offset: Int?
    
    // Note that nil parameters will not be used
    public init(name: String? = nil,
                nameStartsWith: String? = nil,
                limit: Int? = nil,
                offset: Int? = nil) {
        self.name = name
        self.nameStartsWith = nameStartsWith
        self.limit = limit
        self.offset = offset
    }
}
