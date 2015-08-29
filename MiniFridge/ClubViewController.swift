//
//  ClubViewController.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/29/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit


class ClubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var club:Club!
    @IBOutlet weak var memberTableView: UITableView!
    
    //@IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var clubDescription: UITextView!
    @IBOutlet weak var clubTitle: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        clubTitle.text = club.name
        tagline.text = club.tagline
        clubDescription.text = club.description
        
        memberTableView.delegate = self
        memberTableView.dataSource = self

        
    }
    
    override func viewDidDisappear(animated: Bool) {
        club.members.removeAll(keepCapacity: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return club.members.count
    }
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        var cell:MemberCell = tableView.dequeueReusableCellWithIdentifier("MemberCell") as! MemberCell
        cell.backgroundColor = UIColor.clearColor()
        cell.name.text = club.members[indexPath.row].name
        return cell
    }
    
}