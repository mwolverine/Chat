//
//  AddMessageTableViewController.swift
//  Chat
//
//  Created by Chris Yoo on 8/16/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import UIKit

class AddMessageTableViewController: UITableViewController {
    
    var message: Message?
    
    var users: [User] = []
    
    @IBOutlet weak var textLabel: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userLabelText = "To:"
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
        let time = NSDate()
        let users = self.users
        guard let text = textLabel.text
            else {
                let alertController = UIAlertController(title: "Missing Message", message: "Check your message and try again.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
                return }
        MessageController.sharedController.createMessage(time, text: text, user: users, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        return
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let message = message else { return 0}
        return message.texts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addText", forIndexPath: indexPath)
        let text = message?.texts[indexPath.row]
        cell.textLabel?.text = text?.textMessage
        cell.detailTextLabel?.text = text?.textMessage
        
        return cell
    }
    
}
