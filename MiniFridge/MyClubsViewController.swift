//
//  MyClubsViewController.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/28/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct Member{
    var name: String!
    var facebookPicture: String!
    var id: String!
}

struct Club{
    var name: String!
    var description: String!
    var profilePicUrl: String!
    var tagline: String!
    var members = [Member]()
    
}

class MyClubsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = NSUserDefaults.standardUserDefaults();

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    
    var myClubs = [Club]()
    
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
        
        // Make request
        request(.GET, "http://52.3.178.99:3000/clubsByRegistered/\(userId)")
            .responseJSON { (request, response, data, error) in
                println(data)
                var json = JSON(data!)
                var members = [Member]()
                for (key, club) in json {
                    let name = club["name"].stringValue
                    let description = club["description"].stringValue
                    let profilePicUrl = club["profilePicUrl"].stringValue
                    let tagline = club["tagline"].stringValue
                    for(k, member) in club["members"]{
                        members.append(Member(name: member["name"].stringValue, facebookPicture: member["facebook"].stringValue, id: member["id"].stringValue))
                    }
                    self.myClubs.append(Club(name: name, description: description, profilePicUrl: profilePicUrl, tagline: tagline, members: members))
                }
                self.tableView.reloadData()
        }
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myClubs.count
    }
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        var cell:MyClubCell = tableView.dequeueReusableCellWithIdentifier("MyClubCell") as! MyClubCell
        cell.backgroundColor = UIColor.clearColor()
        cell.clubTitle.text = myClubs[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:MyClubCell = tableView.cellForRowAtIndexPath(indexPath)! as! MyClubCell
        selectedCell.contentView.backgroundColor = UIColor(red: 28/255, green: 92/255, blue: 112/255, alpha: 1)
        self.performSegueWithIdentifier("showClubDetail", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "showClubDetail" {
            let viewController:ClubViewController = segue!.destinationViewController as! ClubViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            viewController.club = self.myClubs[indexPath!.row]
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            myClubs.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
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
    
    
    
}

