//
//  UIImageViewCache.swift
//  SlackInterview
//
//  Created by Samuel Kitono on 7/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import UIKit
import ObjectiveC


let imageCache = NSCache<NSString, AnyObject>()
private var xoAssociationKey: UInt8 = 0
extension UIImageView {
    
    var urlSessionTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? URLSessionDataTask
        }
        set(newDataTask) {
            objc_setAssociatedObject(self, &xoAssociationKey, newDataTask, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        self.image = nil
        
        // cancel the url session task if we are trying to load new image here
        if let urlSessionTask =  self.urlSessionTask {
            urlSessionTask.cancel()
        }
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, try to get image from documents folder if it exists
        let fullPathString = FileHelper.fileInDocumentsDirectory(filename: url!.lastPathComponent)
        if FileManager.default.fileExists(atPath: fullPathString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = UIImage(contentsOfFile: fullPathString) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            return
        }
        
        // if not, download image from url
        self.urlSessionTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            if let image = UIImage(data: data!) {
                let filePath = FileHelper.fileURLInDocumentsDirectory(filename:url!.lastPathComponent)
                
                // Create imageData and write to filePath
                do {
                    if let pngImageData = UIImagePNGRepresentation(image) {
                        try pngImageData.write(to: filePath, options: .atomic)
                    }
                    imageCache.setObject(image, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } catch {
                    print("couldn't write image")
                }
            }
        })
        
        self.urlSessionTask!.resume()
    }
}
