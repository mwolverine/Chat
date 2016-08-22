//
//  Message.swift
//  Chat
//
//  Created by Chris Yoo on 8/15/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import UIKit
import CloudKit

class Message: CloudKitSyncable {
    
    var time: NSDate
    var texts: [Text]
    var users: [User] = []
    
    var userReferences: [CKReference] {
        var references: [CKReference] = []
        for user in users {
            if let recordID = user.cloudKitRecordID {
            let reference = CKReference(recordID: recordID, action: .None)
           references.append(reference)
            }
        }
        return references
    }
    
    init(time: NSDate = NSDate(), user: [User] = [], text: [Text] = []) {
        self.time = time
        self.users = user
        self.texts = text
    }
    
    // MARK: CloudKitSyncable
    
    static let typeKey = "Message"
    static let timeKey = "timeKey"
    static let referenceKey = "referenceKey"
    static let userKey = "userkey"
    
    var recordType: String { return Message.typeKey }
    var cloudKitRecordID: CKRecordID?
    
    convenience required init?(record: CKRecord) {
        guard let time = record.creationDate else { return nil }
        self.init(time: time)
        cloudKitRecordID = record.recordID
    }
    
}

extension CKRecord {
    convenience init(_ message: Message) {
        let recordID = CKRecordID(recordName: NSUUID().UUIDString)
        self.init(recordType: message.recordType, recordID: recordID)
        
        self[Message.timeKey] = message.time
    }
}