//
//  UserAPI.swift
//  SwiftChore
//
//  Created by AndrewJRangel on 1/21/16.
//  Copyright © 2016 Antifragile Development. All rights reserved.
//

import Foundation
import Locksmith
import Parse

func getUserID() throws -> String {
    let dictionary = Locksmith.loadDataForUserAccount(vendorID)
    
    if let validDictionary = dictionary {
        if let userID = validDictionary["userID"] as? String {
            return userID
        } else {
            throw LocksmithError.ValidDictionaryInvalidUserID
        }
    } else {
        // create user
        throw LocksmithError.NoValidUser
    }
}

enum LocksmithError:ErrorType {
    case ValidDictionaryInvalidUserID
    case NoValidUser
}

func couldCreateUser(username:String, password:String, email:String, completionHandler:(success:Bool) -> Void) {
    let user = PFUser()
    user.username = username
    user.password = password
    user.email = email
    user["vendorID"] = vendorID
    
    user.signUpInBackgroundWithBlock {
        (succeeded: Bool, error: NSError?) -> Void in
        if let error = error {
            let errorString = error.userInfo["error"] as? NSString
            print(errorString)
            completionHandler(success: false)
            
        } else {
            loginWithCredentials(username, password: password, completionHandler: { (success) -> Void in
                completionHandler(success: success)
            })
        }
    }
}

private func loginWithCredentials(username:String, password:String, completionHandler:(success:Bool) -> Void) {
    
    PFUser.logInWithUsernameInBackground(username, password:password) {
        (user: PFUser?, error: NSError?) -> Void in
        if let user = user, let id = user.objectId {
            do {
                try Locksmith.saveData(["userID": id], forUserAccount: "myUserAccount")
            } catch let error {
                print(error)
            }
            completionHandler(success: true)
        } else {
            completionHandler(success: false)
        }
    }
}