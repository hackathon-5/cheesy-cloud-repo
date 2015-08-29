//
//  ClubViewController.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/29/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit


class ClubViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var club:Club!
    
    //@IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var clubDescription: UITextView!
    @IBOutlet weak var clubTitle: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        clubTitle.text = club.name
        tagline.text = club.tagline
        clubDescription.text = club.description
        
//        if let url = NSURL(string: club.profilePicUrl) {
//            if let data = NSData(contentsOfURL: url){
//                image.contentMode = UIViewContentMode.ScaleAspectFill
//                image.image = UIImage(data: data)
//                image.layer.cornerRadius = self.image.frame.size.width / 2;
//                image.clipsToBounds = true
//                image.layer.borderWidth = 1
//                image.layer.borderColor = UIColor.whiteColor().CGColor
//            }
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}