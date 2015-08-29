//
//  MyCreatedClubsViewController.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/29/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class MyCreatedClubsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = NSUserDefaults.standardUserDefaults();
    var myClubs = [Club]()
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.separatorColor = UIColor(red: 180, green: 180, blue: 180, alpha: 30)
        tableView.delegate = self
        tableView.dataSource = self
        
        var userId = ""
        
        if let id = defaults.stringForKey("id"){
            userId = id
        }
        
        println(userId)
        
        // Make request
        request(.GET, "http://52.3.178.99:3000/clubsByOwner/\(userId)")
            .responseJSON { (request, response, data, error) in
                println(data)
                var json = JSON(data!)
                var members = [Member]()
                for (key, club) in json {
                    let id = club["_id"].stringValue
                    let name = club["name"].stringValue
                    let description = club["description"].stringValue
                    let profilePicUrl = club["profilePicUrl"].stringValue
                    let tagline = club["tagline"].stringValue
                    for(k, member) in club["members"]{
                        members.append(Member(name: member["name"].stringValue, facebookPicture: member["facebook"].stringValue, id: member["id"].stringValue))
                    }
                    self.myClubs.append(Club(id: id, name: name, description: description, profilePicUrl: profilePicUrl, tagline: tagline, members: members))
                }
                self.tableView.reloadData()
        }

    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myClubs.count
    }
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        var cell:MyCreatedClubCell = tableView.dequeueReusableCellWithIdentifier("MyCreatedClubCell") as! MyCreatedClubCell
        cell.backgroundColor = UIColor.clearColor()
        cell.clubTitle.text = myClubs[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:MyCreatedClubCell = tableView.cellForRowAtIndexPath(indexPath)! as! MyCreatedClubCell
        selectedCell.contentView.backgroundColor = UIColor(red: 28/255, green: 92/255, blue: 112/255, alpha: 1)
        self.performSegueWithIdentifier("showQRCode", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                var club = myClubs[indexPath.row].id
                // remove the deleted item from the model
                self.myClubs.removeAtIndex(indexPath.row)
                
                // Make request
                request(.GET, "http://52.3.178.99:3000/club/delete/\(club)")
                    .responseJSON { (request, response, data, error) in
                        println("deleted")
                        
                }
                
                // remove the deleted item from the `UITableView`
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        
        // Remove separator inset
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "showQRCode" {
            let viewController:ShowQRCode = segue!.destinationViewController as! ShowQRCode
            let indexPath = self.tableView.indexPathForSelectedRow()
            viewController.club = self.myClubs[indexPath!.row]
        }
        
    }

    
    
    
}