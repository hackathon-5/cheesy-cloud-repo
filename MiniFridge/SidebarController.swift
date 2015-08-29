//
//  SidebarController.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/28/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

struct Option{
    var name:String!
    var imageName: String!
    var segueName: String!
}

class SidebarController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = NSUserDefaults.standardUserDefaults();
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileName: UILabel!
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    var options: [Option] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        options.append(Option(name: "My Clubs", imageName: "clubs.png", segueName: "myClubs"))
        options.append(Option(name: "My Created Clubs", imageName: "home.png", segueName: "myCreatedClubs"))
        options.append(Option(name: "Create Club", imageName: "plus.png", segueName: "createClub"))
        options.append(Option(name: "Signup", imageName: "pencil.png", segueName: "signup"))
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let imageData = defaults.dataForKey("image"){
            profileImage.contentMode = UIViewContentMode.ScaleAspectFit
            profileImage.image = UIImage(data: imageData)
            profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
            profileImage.clipsToBounds = true
            profileImage.layer.borderWidth = 1
            profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
        if let name = defaults.stringForKey("name"){
            profileName.text = name
        }
        
        self.view.backgroundColor = UIColor(red: CGFloat(43/255.0), green: CGFloat(43/255.0), blue: CGFloat(43/255.0), alpha: CGFloat(1.0))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return options.count
    }
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        var cell:SidebarCell = tableView.dequeueReusableCellWithIdentifier("SidebarCell") as! SidebarCell
        cell.backgroundColor = UIColor(red: CGFloat(43/255.0), green: CGFloat(43/255.0), blue: CGFloat(43/255.0), alpha: CGFloat(1.0))
        cell.title.text = options[indexPath.row].name
        cell.thumbnail?.image = UIImage(named: options[indexPath.row].imageName)

        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:SidebarCell = tableView.cellForRowAtIndexPath(indexPath)! as! SidebarCell
        selectedCell.contentView.backgroundColor = UIColor(red: 28/255, green: 92/255, blue: 112/255, alpha: 1)
        self.performSegueWithIdentifier(options[indexPath.row].segueName, sender: self)
        
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

