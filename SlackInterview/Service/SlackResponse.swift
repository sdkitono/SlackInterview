//
//  SlackResponse.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 6/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation

/// Top level response for every request to the Slack API
/// Everything in the API seems to be optional, so we cannot rely on having values here


// basic structure of slack api
// {
//    "ok": false,
//    "error": "something_bad"
//    "warning" : "something_problematic"
// }
public protocol SlackResponseProtocol {
    associatedtype Response
    var ok:Bool? { get }
    var error:String? { get }
    var warning:String? { get }
    var data: Response? { get }
}

