//
//  CloudKitSyncable.swift
//  Chat
//
//  Created by Chris Yoo on 8/17/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitSyncable: class {
    init?(record: CKRecord)
    
    var cloudKitRecordID: CKRecordID? { get set}
    var recordType: String { get }
}

extension CloudKitSyncable {
    var isSynced: Bool {
        return cloudKitRecordID != nil
    }
    
    var cloudKitReference: CKReference? {
        guard let recordID = cloudKitRecordID else { return nil }
        return CKReference(recordID: recordID, action: .None)
    }
    
}