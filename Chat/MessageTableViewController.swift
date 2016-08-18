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

    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageController.sharedController.messages.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)

        let message = MessageController.sharedController.messages[indexPath.row]
        
        cell.detailTextLabel?.text = String(message.time)
        
        return cell
    }


   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
