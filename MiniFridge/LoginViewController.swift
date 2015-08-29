//
//  ViewController.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/28/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults();

    @IBAction func loginPressed(sender: AnyObject) {
        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                var fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    if let email = result.objectForKey("email"){
                        self.defaults.setObject(email, forKey: "email");
                    }
                    
                    if let name = result.objectForKey("name"){
                        self.defaults.setObject(name, forKey: "name");
                    }
                    
                    if let id = result.objectForKey("id"){
                        self.defaults.setObject(id, forKey: "id");
                    }
                    
                    if let picture = result.objectForKey("picture"){
                        if let data = picture.objectForKey("data"){
                            if let imageUrl = data.objectForKey("url"){
                                self.defaults.setObject(imageUrl, forKey:"imageUrl")
                                if let url = NSURL(string: imageUrl as! String) {
                                    if let data = NSData(contentsOfURL: url){
                                        self.defaults.setObject(data, forKey: "image")
                                    }
                                }
                            }
                        }
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                    

                } else {
                    println("Shit")
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(FBSDKAccessToken.currentAccessToken() != nil){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

