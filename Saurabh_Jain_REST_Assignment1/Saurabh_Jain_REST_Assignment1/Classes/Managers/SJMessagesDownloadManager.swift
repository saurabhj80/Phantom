//
//  SJMessagesDownloadManager.swift
//  Saurabh_Jain_REST_Assignment1
//
//  Created by Saurabh Jain on 9/19/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

// Error Domain
public let SJMessagesManagerDownloadErrorDomain = "SJMessagesDownloadManagerErrorDomain"
public let SJMessagesManagerDeleteErrorDomain   = "SJMessagesManagerDeleteErrorDomain"

public class SJMessagesManager: NSObject {

    // The URL to hit
    private let DownloadURL = "https://freezing-cloud-6077.herokuapp.com/messages.json"
    private let DeleteURL = "https://freezing-cloud-6077.herokuapp.com/messages/"
    
    // An instance on NSURLSession
    private var session: NSURLSession
    
    override init() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    // MARK: Download
    
    public func downloadMessages(block: ([[NSObject: AnyObject]]?, NSError?) -> ()) {
        
        // Create the url
        let url = NSURL(string: DownloadURL)
        
        // if the URL does not exist, then call the handler, with the error
        guard let URL = url else {
            block(nil, NSError(domain: SJMessagesManagerDownloadErrorDomain, code: SJMessagesDownloadManagerError.WrongURL, userInfo: nil));
            return
        }
        
        // Create a data task with NSURLSession
        let request = NSURLRequest(URL: URL)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            // If Error exists
            if (error != nil) {
                block(nil, error);
            }
            
            else {
                
                // If data does not exist
                guard let data = data else {
                    block(nil, NSError(domain: SJMessagesManagerDownloadErrorDomain, code: SJMessagesDownloadManagerError.NoDataReceived, userInfo: nil))
                    return
                }
                
                // NSJSONSerialization throws an exception
                // Hence the try block
                do {
                    // JSON Serialized
                    let d = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                    if let dic = d as? [[NSObject: AnyObject]] {
                        block(dic, nil)
                    } else {
                        block(nil, nil)
                    }
                    
                } catch _ {
                    // If exception thrown, it means parsing error
                    block(nil, NSError(domain: SJMessagesManagerDownloadErrorDomain, code: SJMessagesDownloadManagerError.ParsingError, userInfo: nil))
                    return
                }
            }
        }
        
        // Start the task
        task.resume()
    }
    
    // MARK: Delete
    
    public func deleteMessage(id: Int, block: (NSError?) -> Void) {
        
        // Create URL
        let url = NSURL(string: DeleteURL + "\(id)")
        
        guard let URL = url else {
            block(NSError(domain: SJMessagesManagerDeleteErrorDomain, code: SJMessagesManagerDeleteError.WrongURL, userInfo: nil))
            return
        }
        
        // Create Request
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "DELETE"

        // Create NSURLSessionDataTask
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // 404 code is returned on success
            
//            if let resonse = response as? NSHTTPURLResponse {
//                if resonse.statusCode != 200 {
//                    block(NSError(domain: SJMessagesManagerDownloadErrorDomain, code: SJMessagesManagerDeleteError.ServerResponseCode, userInfo: ["Status Code": resonse.statusCode]))
//                }
//            } else {
//                block(error)
//            }
            block(error)
        }
        
        // Begin task
        task.resume()
    }
    
    // MARK: POST
    
    public func postMessage(data: NSData, block: (NSError?) -> Void) {
        
        let url = NSURL(string: DownloadURL)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.uploadTaskWithRequest(request, fromData: data) { (data, response, error) in
            block(error)
        }
        
        task.resume()
    }
}

// Download Error
public enum SJMessagesDownloadManagerError: Int {
    case WrongURL = 0
    case NoDataReceived = 1
    case ParsingError = 2
}

// Delete Error
public enum SJMessagesManagerDeleteError: Int {
    case WrongURL = 0
    case ServerResponseCode = 1
}

private extension NSError {
    convenience init(domain: String, code: SJMessagesDownloadManagerError, userInfo: [NSObject: AnyObject]?) {
        self.init(domain: domain, code: code.rawValue, userInfo: userInfo)
    }
    convenience init(domain: String, code: SJMessagesManagerDeleteError, userInfo: [NSObject: AnyObject]?) {
        self.init(domain: domain, code: code.rawValue, userInfo: userInfo)
    }
}

