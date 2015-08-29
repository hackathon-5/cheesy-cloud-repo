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

class MyClubsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    
    var myClubs = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.separatorColor = UIColor(red: 180, green: 180, blue: 180, alpha: 30)
        tableView.delegate = self
        tableView.dataSource = self
   
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
        
        var cell:SidebarCell = tableView.dequeueReusableCellWithIdentifier("SidebarCell") as! SidebarCell
        cell.backgroundColor = UIColor.clearColor()
        //cell.title.text = options[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:SidebarCell = tableView.cellForRowAtIndexPath(indexPath)! as! SidebarCell
        selectedCell.contentView.backgroundColor = UIColor(red: 28/255, green: 92/255, blue: 112/255, alpha: 1)
        //self.performSegueWithIdentifier(options[indexPath.row].segueName, sender: self)
        
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

