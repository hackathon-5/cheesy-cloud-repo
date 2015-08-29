
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

class CreatePostViewController: UIViewController {
    let defaults = NSUserDefaults.standardUserDefaults();
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtBody: UITextView!
    
    @IBOutlet weak var menuButton: UIButton!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    @IBAction func createPost(sender: AnyObject) {
        let headers = [
            "Content-Type":"application/json"
        ]
        var clubId = 0
        
        
        let title = txtTitle.text
        let body = txtBody.text
        
        var jsonBody = [
            "title": title,
            "body":body
        ]
        
        // Use Alamofire to make POST request
        request(.POST, "http://52.3.178.99:3000/club/post/\(clubId)", parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = JSON(jsonBody).rawData()
            return (mutableRequest, nil)
        }), headers:headers)
            .responseString { [weak self] request, response, string, error in
                println(response)
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}