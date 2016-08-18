//
//  UserMC.swift
//  Chat
//
//  Created by Chris Yoo on 8/15/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import UIKit
import CloudKit

class UserController {
    
    static let sharedController = UserController()
    
    var users: [User] = []
    var cloudKitManager = CloudKitManager()
    
    
    func createNewUser() {
        
        cloudKitManager.fetchLoggedInUserRecord { (record, error) in
            
            guard let record = record else {
                if let error = error {
                    NSLog("Error getting record on logged in user: \(error)")
                    return
                }
                return
            }
            self.cloudKitManager.fetchUsernameFromRecordID(record.recordID, completion: { (givenName, familyName) in
                guard let firstname = givenName, lastName = familyName else { return }
                let user = User(firstName: firstname, lastName: lastName)
                self.users.append(user)
                
                let newUserRecord = CKRecord(recordType: User.typeKey)
                let reference = CKReference(recordID: record.recordID, action: .None)
                
                newUserRecord.setValue(reference, forKey: "identifier")
                newUserRecord.setValue(user.firstName, forKey: User.firstNameKey)
                newUserRecord.setValue(user.lastName, forKey: User.lastNameKey)
                
                self.cloudKitManager.saveRecord(newUserRecord, completion: { (record, error) in
                    if let error = error {
                        NSLog("Error saving user to CloudKit: \(error)")
                        return
                    }
                    
                })
                
            })
        }
    }
}
