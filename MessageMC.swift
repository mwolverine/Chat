//
//  MessageMC.swift
//  Chat
//
//  Created by Chris Yoo on 8/15/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import UIKit
import CloudKit

class MessageController {
    
    static let sharedController = MessageController()
    
    var cloudKitManager = CloudKitManager()
    var messages: [Message] = []
    var texts: [Text] {
        return messages.flatMap { $0.texts }
    }
    var users: [User] = []
    
    init() {
        self.cloudKitManager = CloudKitManager()
    }
    
    func createMessage(time: NSDate, text: String, user: [User], completion: ((Message) -> Void)?)
    {
        let message = Message(time: time)
        messages.append(message)
        
        let textMessage = createText(text, message: message)
        let record = CKRecord(message)
        record.setValue(message.userReferences, forKey: Message.referenceKey)
        self.cloudKitManager.saveRecord(record) { (record, error) in
            guard let record = record else {
                if let error = error {
                    NSLog("Error saving new message to CloudKit: \(error)")
                    return
                }
                completion?(message)
                return
            }
            
            message.cloudKitRecordID = record.recordID
            self.cloudKitManager.saveRecord(CKRecord(textMessage), completion: { (record, error) in
                if let error = error {
                    NSLog("Error saving new text to CloudKit: \(error)")
                    return
                }
                textMessage.cloudKitRecordID = record!.recordID
                completion?(message)
            })
        }
    }
    
    func createText(text: String, message: Message, completion: ((Text) -> Void)? = nil) -> Text
    {
//        guard let imageData = UIImagePNGRepresentation(image) else { return  }
        let text = Text(textMessage: text, time: NSDate(), message: message)
        message.texts.append(text)
        
        self.cloudKitManager.saveRecord(CKRecord(text)) { (record, error) in
            if let error = error {
                NSLog("Error saving new text to CloudKit: \(error)")
                return
            }
            text.cloudKitRecordID = record?.recordID
            completion?(text)
        }
        return text
    }
    
//    func fetchNewMessage(message: Message) {
//        var predicate: NSPredicate(
//        let sortDescriptor = [NSSortDescriptor(key: Message.timeKey, ascending: false)]
//        let recordType = Message.typeKey
//        
//        cloudKitManager.fetchRecordsWithType(recordType, predicate: predicate, recordFetchedBlock: <#T##((record: CKRecord) -> Void)?##((record: CKRecord) -> Void)?##(record: CKRecord) -> Void#>, completion: <#T##((records: [CKRecord]?, error: NSError?) -> Void)?##((records: [CKRecord]?, error: NSError?) -> Void)?##(records: [CKRecord]?, error: NSError?) -> Void#>)
//    }
}

