//
//  MessageTableViewController.swift
//  Chat
//
//  Created by Chris Yoo on 8/16/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.sharedController.createNewUser()
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.sharedController.messages.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)
        
        let message = MessageController.sharedController.messages[indexPath.row]
        guard let text = message.texts.first?.textMessage else { return UITableViewCell() }
        cell.textLabel?.text = String(text)
        cell.detailTextLabel?.text = String(message.time)
        
        return cell
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "textSegue" {
            if let textVC = segue.destinationViewController as? AddMessageTableViewController, indexPath = tableView.indexPathForSelectedRow?.row {
                let message = MessageController.sharedController.messages[indexPath]
                textVC.message = message
                
            }
        }
    }
}
