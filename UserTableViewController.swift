//
//  UserTableViewController.swift
//  Chat
//
//  Created by Chris Yoo on 8/17/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//


import UIKit

class UserTableViewController: UITableViewController {
    
    var cloudKitManager = CloudKitManager()
    
    var users: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.sharedController.users.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        let user = UserController.sharedController.users[indexPath.row]
        
        cell.textLabel?.text = user.firstName + " " + user.lastName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    
    
     // MARK: - Navigation
     
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "composeSegue" {
            if let composeVC = segue.destinationViewController as? AddMessageTableViewController, selectedIndexes = tableView.indexPathsForSelectedRows {
                var usersArray: [User] = []
                for index in selectedIndexes {
                    let user = UserController.sharedController.users[index.row]
                    usersArray.append(user)
                }
                composeVC.users = usersArray
                
            }
        }
     }
}
