//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Sanchay  Javeria on 6/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    var usrMsgs = [String]()
    var usrNames = [String]()
    var usrImgs = [PFFile]()
    var userID = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        query?.findObjectsInBackgroundWithBlock({ (object, error) in
                if error != nil {
                    print(error)
                }
                self.usrImgs.removeAll(keepCapacity: true)
                self.usrNames.removeAll(keepCapacity: true)
                self.usrMsgs.removeAll(keepCapacity: true)
                self.userID.removeAll(keepCapacity: true)
                if let users = object {
                    for x in users {
                        if let user = x as? PFUser {
                            self.userID[user.objectId!] = user.username!
                        }
                    }
                }

            let query = PFQuery(className: "followers")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
           query.findObjectsInBackgroundWithBlock { (objects, error) in
                if let objects = objects {
                    for object in objects {
                        let followUser = object["following"] as! String
                        let newQuery = PFQuery(className: "Post")
                        newQuery.whereKey("userId", equalTo: followUser)
                        newQuery.findObjectsInBackgroundWithBlock({ (newObjects, error) in
                            if let newObjects = newObjects {
                                for new in newObjects {
                                    self.usrMsgs.append(new["caption"]! as! String)
                                    self.usrImgs.append(new["imageFile"]! as! PFFile)
                                    self.usrNames.append(self.userID[new["userId"] as! String]!)
                                    self.tableView.reloadData()
                                }
                            }
                        })
                    }
                }
            }
        })

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
        return usrNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cell
        
        usrImgs[indexPath.row].getDataInBackgroundWithBlock { (data, error) in
            if error == nil {
                if let finalImg = UIImage(data: data!) {
                    Cell.postedimg.image = finalImg
                }
            }
        }
        Cell.username.text = usrNames[indexPath.row]
        Cell.caption.text = usrMsgs[indexPath.row]
        
        return Cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
