//
//  SlackUsersResponse.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 7/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation

// User structure
// {
//    "ok": true,
//    "members": [...]
// }
public struct SlackUsersResponse: Decodable, SlackResponseProtocol {
    
    public typealias Response = [SlackUser]
    
    /// Whether it was ok or not
    public let ok: Bool?
    /// Message that usually gives more information about some error
    public let error: String?
    
    public let warning: String?
    
    /// Requested data
    public let members: Response?
    
    public var data: Response? {
        return self.members
    }
}
