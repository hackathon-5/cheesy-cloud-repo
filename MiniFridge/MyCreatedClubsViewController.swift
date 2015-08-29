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
    var myClubs = [String]()
    
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
                var json = JSON(data!)
                for (key, club) in json {
                    let name = club["name"].stringValue
                    self.myClubs.append(name)
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
        cell.clubTitle.text = myClubs[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:SidebarCell = tableView.cellForRowAtIndexPath(indexPath)! as! SidebarCell
        selectedCell.contentView.backgroundColor = UIColor(red: 28/255, green: 92/255, blue: 112/255, alpha: 1)
        //self.performSegueWithIdentifier(options[indexPath.row].segueName, sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}