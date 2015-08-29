//
//  MyPostViewController.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/28/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct Post{
    var title: String!
    var body: String!
}

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = NSUserDefaults.standardUserDefaults();
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    
    var myPosts = [Post]()
    
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
                var json = JSON(data!)
                for (key, post) in json {
                    let title = post["title"].stringValue
                    let body = post["body"].stringValue
                    self.myPosts.append(Post(title: title, body: body))
                }
                self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myPosts.count
    }
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        var cell:MyPostCell = tableView.dequeueReusableCellWithIdentifier("MyPostCell") as! MyPostCell
        cell.backgroundColor = UIColor.clearColor()
        //cell.postTitle.text = myPosts[indexPath.row].title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:MyPostCell = tableView.cellForRowAtIndexPath(indexPath)! as! MyPostCell
        selectedCell.contentView.backgroundColor = UIColor(red: 28/255, green: 92/255, blue: 112/255, alpha: 1)
        self.performSegueWithIdentifier("showClubDetail", sender: self)
        
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

