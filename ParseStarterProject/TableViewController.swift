//
//  TableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Sanchay  Javeria on 6/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    var usernames = [""]
    var userID = [""]
    var isFollowing = ["":false]
    var refresh: UIRefreshControl!


    func refreshFunction() {
        if (PFUser.currentUser()?.objectId != nil) {
            let query = PFUser.query()
            query?.findObjectsInBackgroundWithBlock({ (object, error) in
                if error != nil {
                    print(error)
                }
                self.usernames.removeAll(keepCapacity: true)
                self.userID.removeAll(keepCapacity: true)
                self.isFollowing.removeAll(keepCapacity: true)
                if let users = object {
                    for x in users {
                        if let user = x as? PFUser {
                            if user.objectId != PFUser.currentUser()?.objectId{
                                self.usernames.append(user.username!)
                                self.userID.append(user.objectId!)
                                let newQuery = PFQuery(className: "followers")
                                newQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                                newQuery.whereKey("following", equalTo: user.objectId!)
                                newQuery.findObjectsInBackgroundWithBlock({ (object, error) in
                                    if let object = object {
                                        if object.count > 0 {
                                            self.isFollowing[user.objectId!] = true
                                        }
                                        else{
                                            self.isFollowing[user.objectId!] = false
                                        }
                                    }
                                    
                                    if self.isFollowing.count == self.usernames.count {
                                        self.tableView.reloadData()
                                        self.refresh.endRefreshing()
                                    }
                                })
                            }
                            
                        }
                        
                    }
                    
                }
                
            })
        } else {
            performSegueWithIdentifier("sign up", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        refresh.addTarget(self, action: "refreshFunction", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)
        refreshFunction()
        if (PFUser.currentUser()?.objectId != nil){
            let query = PFUser.query()
            query?.findObjectsInBackgroundWithBlock({ (object, error) in
                if error != nil {
                    print(error)
                }
                self.usernames.removeAll(keepCapacity: true)
                self.userID.removeAll(keepCapacity: true)
                self.userID.removeAll(keepCapacity: true)
                if let users = object {
                    for x in users {
                        if let user = x as? PFUser {
                            if user.objectId != PFUser.currentUser()?.objectId{
                                self.usernames.append(user.username!)
                                self.userID.append(user.objectId!)
                                let newQuery = PFQuery(className: "followers")
                                newQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
                                newQuery.whereKey("following", equalTo: user.objectId!)
                                newQuery.findObjectsInBackgroundWithBlock({ (object, error) in
                                    if let object = object {
                                            if object.count > 0 {
                                            self.isFollowing[user.objectId!] = true
                                        }
                                     else{
                                            self.isFollowing[user.objectId!] = false
                                        }
                                    }
                                    
                                    if self.isFollowing.count == self.usernames.count {
                                        self.tableView.reloadData()
                                    }
                                })
                            }
                            
                        }
                       
                    }
                   
                }
                
            })
        } else {
            performSegueWithIdentifier("sign up", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = usernames[indexPath.row]
        let getId = userID[indexPath.row]
        if isFollowing[getId] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let getId = userID[indexPath.row]
        if isFollowing[getId] == false {
            isFollowing[getId] = true
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            let following = PFObject(className: "followers")
            following["following"] = userID[indexPath.row]
            following["follower"] = PFUser.currentUser()?.objectId
            following.saveInBackground()
        } else {
            isFollowing[getId] = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            let newQuery = PFQuery(className: "followers")
            newQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
            newQuery.whereKey("following", equalTo: userID[indexPath.row])
            newQuery.findObjectsInBackgroundWithBlock({ (object, error) in
                if let object = object {
                    for x in object {
                        x.deleteInBackground()
                    }
                }
            })
        }
    }
}
