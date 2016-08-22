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
    var isSyncing: Bool = false
    
    init() {
        self.cloudKitManager = CloudKitManager()
        performFullSync()
    }
    
    func createMessage(time: NSDate, text: String, user: [CKReference], completion: ((Message) -> Void)?)
    {
        let message = Message(time: time)
        messages.append(message)
        
        let textMessage = createText(text, message: message)
        let record = CKRecord(message)
        record.setValue(user, forKey: Message.referenceKey)
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
    
    private func recordsOfType(type: String) -> [CloudKitSyncable] {
        switch type {
        case "Message":
            return messages.flatMap({$0 as CloudKitSyncable})
        case "Text":
            return texts.flatMap({ $0 as CloudKitSyncable })
        default:
            return []
            
        }
    }
    
    func fetchNewRecords (type: String, completion: (()->Void)?=nil){
        var referencesToExclude = [CKReference]()
        var predicate: NSPredicate!
        referencesToExclude = self.syncedRecords(type).flatMap({ $0.cloudKitReference })
        predicate = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: [referencesToExclude])
        if referencesToExclude.isEmpty{
            predicate = NSPredicate(value: true)
        }
        
        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            switch type {
            case Message.typeKey:
                if let message = Message(record: record){
                    self.messages.append(message)
                }
            case Text.typeKey:
                guard let messageReference = record[Text.messageKey] as? CKReference,
                    messageIndex = self.messages.indexOf({ $0.cloudKitRecordID == messageReference.recordID }), text = Text(record: record)              else { return }
                let message = self.messages[messageIndex]
                message.texts.append(text)
                text.message = message
            default:
                return
            }
        }) { (records, error) in
            if let error = error {
                NSLog("Error fetching CloudKit ecords of type \(type): \(error)")
            }
            completion?()
        }
    }
    
    func pushChangesToCloudKit(completion: ((success: Bool, error: NSError?) -> Void)?) {
        
        let unsavedMessages = unsyncedRecords(Message.typeKey) as? [Message] ?? []
        let unsavedTexts = unsyncedRecords(Text.typeKey) as? [Text] ?? []
        var unsavedObjectsByRecord = [CKRecord: CloudKitSyncable]()
        for message in unsavedMessages {
            let record = CKRecord(message)
            unsavedObjectsByRecord[record] = message
        }
        
        for text in unsavedTexts {
            let record = CKRecord(text)
            unsavedObjectsByRecord[record] = text
        }
        
        let unsavedRecords = Array(unsavedObjectsByRecord.keys)
        
        cloudKitManager.saveRecords(unsavedRecords, perRecordCompletion: { (record, error) in
            guard let record = record else { return }
            unsavedObjectsByRecord[record]?.cloudKitRecordID = record.recordID
        }) { (records, error) in
            let success = records != nil
            completion?(success: success, error: error)
        }
    }
    
    func performFullSync(completion: (()->Void)? = nil){
        guard !isSyncing else {
            completion?()
            return}
        isSyncing = true
        
        pushChangesToCloudKit { (success) in
            self.fetchNewRecords(Message.typeKey) {
                self.fetchNewRecords(Text.typeKey) {
                    self.isSyncing = false
                    completion?()
                    
                }
            }
        }
    }
    
    
    
    func syncedRecords (type: String) -> [CloudKitSyncable] {
        return recordsOfType(type).filter { $0.isSynced }
    }
    
    func unsyncedRecords (type: String) -> [CloudKitSyncable] {
        return recordsOfType(type).filter { !$0.isSynced }
    }
}

