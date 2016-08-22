//
//  AddMessageTableViewController.swift
//  Chat
//
//  Created by Chris Yoo on 8/16/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import UIKit
import CloudKit

class AddMessageTableViewController: UITableViewController {
    
    var message: Message?
    
    var users: [User] = []
    
    @IBOutlet weak var textLabel: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userLabelText = "To: "
        for user in users {
            let usersFirstName = user.firstName
            userLabelText += usersFirstName
            tableView.reloadData()
        }
        userLabel.text = userLabelText
    }
    
    //    var texts: [Text] {
    //        return messages.flatMap { $0.texts }
    //    }
    
    @IBAction func addMessage(sender: AnyObject){
//        if message?.texts == nil {
            let time = NSDate()
            let users = self.users
            guard let text = textLabel.text
                else {
                    let alertController = UIAlertController(title: "Missing Message", message: "Check your message and try again.", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    presentViewController(alertController, animated: true, completion: nil)
                    return }
            
            let userReference = users.flatMap({$0.userReference})
            
            MessageController.sharedController.createMessage(time, text: text, user: userReference, completion: nil)
            
//        }
//            
//        else {
//            guard let text = textLabel.text, message = message else {
////                let alertController = UIAlertController(title: "Missing Text", message: "Check your text and try again.", preferredStyle: .Alert)
////                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
////                presentViewController(alertController, animated: true, completion: nil)
//                return }
//            
//            
//            MessageController.sharedController.createText(text, message: message, completion: nil)
//            MessageController.sharedController.performFullSync()
//            self.tableView.reloadData()
//            return
//        }
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let message = message else { return 0 }
        return message.texts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addText", forIndexPath: indexPath)
        let text = message?.texts[indexPath.row]
        cell.textLabel?.text = text?.textMessage
        cell.detailTextLabel?.text = String(text?.time)
        
        return cell
    }
    
}
