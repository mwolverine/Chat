//
//  Text.swift
//  Chat
//
//  Created by Chris Yoo on 8/15/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import UIKit
import CloudKit

class Text: CloudKitSyncable {
    
    let textMessage: String
    let time: NSDate
    var imageData: NSData?
    var message: Message?
    var reference: CKReference?
    var image: UIImage? {
        guard let imageData = self.imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    init(textMessage: String, time: NSDate = NSDate(), message: Message?) {
        self.textMessage = textMessage
        self.time = time
//        self.imageData = imageData
//        self.reference = reference
        self.message = message
    }
    
    // MARK: CloudKitSyncable

    static let typeKey = "Text"
    static let textMessageKey = "textMessage"
    static let timeKey = "time"
    static let imageDataKey = "imageDataKey"
    static let messageKey =  "message"
    static let referenceKey = "reference"
    
    var recordType: String { return Text.typeKey }
    var cloudKitRecordID: CKRecordID?
    
    private var temporaryPhotoURL: NSURL {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = NSURL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.URLByAppendingPathComponent(NSUUID().UUIDString).URLByAppendingPathExtension("jpg")
        imageData?.writeToURL(fileURL, atomically: true)
        return fileURL
    }
    
    convenience required init?(record: CKRecord){
        guard let time = record.creationDate, textMessage = record[Text.textMessageKey] as? String else { return nil }
//        reference = record[Text.referenceKey] as? CKReference
//        let imageData = NSData(contentsOfURL: photoAsset.fileURL)
        self.init(textMessage: textMessage, time: time, message: nil)
        cloudKitRecordID = record.recordID
    }
}

extension CKRecord {
    convenience init(_ text: Text){
        guard let message = text.message else { fatalError("Comment does not have relationship with Post")}
        let messageRecordID = message.cloudKitRecordID ?? CKRecord(message).recordID
        let recordID = CKRecordID(recordName: NSUUID().UUIDString)
        
        self.init(recordType: text.recordType, recordID: recordID)
        
        self[Text.timeKey] = text.time
        self[Text.textMessageKey] = text.textMessage
//        self[Text.imageDataKey] = CKAsset(fileURL: text.temporaryPhotoURL)
        self[Text.messageKey] = CKReference(recordID: messageRecordID, action: .DeleteSelf)

    }
    
}