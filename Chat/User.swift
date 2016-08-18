//
//  User.swift
//  Chat
//
//  Created by Chris Yoo on 8/15/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import UIKit
import CloudKit

class User {
    
    var firstName: String
    var lastName: String
    
    init(firstName: String, lastName: String){
        self.firstName = firstName
        self.lastName = lastName
    }
    
    // MARK: CloudKitSyncable
    
    static let typeKey = "User"
    static let firstNameKey = "firstname"
    static let lastNameKey = "lastname"
    
    var recordType: String { return User.typeKey }
    
    var cloudKitRecordID: CKRecordID?
    
    convenience required init?(record: CKRecord) {
        guard let firstName = record[User.firstNameKey] as? String, let lastName = record[User.lastNameKey] as? String else { return nil }
        self.init(firstName: firstName, lastName: lastName)
        cloudKitRecordID = record.recordID
    }
}

extension CKRecord {
    convenience init(_ user: User) {
        let recordID = CKRecordID(recordName: NSUUID().UUIDString)
        self.init(recordType: user.recordType, recordID: recordID)
        
        self[User.firstNameKey] = user.firstName
        self[User.lastNameKey] = user.lastName
    }
}
  