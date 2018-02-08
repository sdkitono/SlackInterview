//
//  SlackUser.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 6/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation

public struct SlackUser: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case realName = "real_name"
        case deleted
        case updated
        case profile
    }
    
    public let id: String?
    public let name: String?
    public let realName: String?
    public let deleted: Bool?
    public let updated: TimeInterval?
    public let profile: SlackUserProfile?
}

public struct SlackUserProfile: Decodable {
    public let title: String?
    public let phone: String?
    public let skype: String?
    public let email: String?
    public let image48: String?
    public let image192: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case phone
        case skype
        case email
        case image48 = "image_48"
        case image192 = "image_192"
    }
}

