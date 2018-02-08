//
//  FileHelper.swift
//  RoverInterview
//
//  Created by Samuel Kitono on 27/1/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import Foundation

class FileHelper {
    static func getDocumentsURL() -> URL {
        let fileManager = FileManager.default
        // Get the URL for the users home directory
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL
    }
    
    static func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
    
    static func fileURLInDocumentsDirectory(filename: String) -> URL {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL
    }
}
