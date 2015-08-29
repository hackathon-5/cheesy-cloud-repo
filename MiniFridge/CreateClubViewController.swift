
//
//  CreateClubViewController.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/29/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class CreateClubViewController: UIViewController, UITableViewDelegate {
    let defaults = NSUserDefaults.standardUserDefaults();
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtTagline: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtPic: UITextField!
    @IBOutlet weak var menuButton: UIButton!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    @IBAction func createClub(sender: AnyObject) {
        let headers = [
            "Content-Type":"application/json"
        ]
        var ownerId = 0
        
        if let id = defaults.stringForKey("id"){
            ownerId = id.toInt()!
        }
        
        
        let name = txtName.text
        let tagline = txtTagline.text
        let description = txtDescription.text
        let pic = txtPic.text
        
        var jsonBody = [
            "ownerId":ownerId,
            "name": name,
            "tagline":tagline,
            "description":description,
            "profilePicUrl":pic
        ]
        
        
        // Use Alamofire to make POST request
        request(.POST, "http://52.3.178.99:3000/club/save", parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = JSON(jsonBody).rawData()
            return (mutableRequest, nil)
        }), headers:headers)
            .responseString { [weak self] request, response, string, error in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                self!.presentViewController(vc, animated: true, completion: nil)
        }
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}