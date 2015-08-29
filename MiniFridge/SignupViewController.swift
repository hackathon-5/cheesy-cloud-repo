//
//  SignupViewController.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/29/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class SignupViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    let defaults = NSUserDefaults.standardUserDefaults();

    
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var closeButton     : UIView = UIView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin |
            UIViewAutoresizing.FlexibleBottomMargin |
            UIViewAutoresizing.FlexibleLeftMargin |
            UIViewAutoresizing.FlexibleRightMargin
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        view.addSubview(self.highlightView)
        captureQRCode()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureQRCode() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: nil) as! AVCaptureDeviceInput
        session.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        let bounds = self.view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = self.view.layer.frame
        
        self.cameraView.layer.addSublayer(previewLayer)
        session.startRunning()
    }
    
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        var detectionString : String!
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        var valid = false
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    
                    highlightViewRect = barCodeObject.bounds
                    
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    self.session.stopRunning()
                    
                    valid = true
                    
                }
                
            }
        }
        
        if valid {
            registerForClub(detectionString)
        } else {
            self.closeView()
        }
    }
    
    
    func closeView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Main") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func registerForClub(clubId: String) {
        
        let params = [
            "clubId":clubId
        ]
        
//        // Make request
//        request(.GET, "52.3.178.99:3000/api/es/getShipmentDetails", parameters: params)
//            .responseJSON { (req, res, json, error) in
//                if(error != nil) {
//                    var alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "Close", style: .Default, handler: { action in
//                        switch action.style{
//                        case .Default:
//                            self.closeView()
//                        case .Cancel:
//                            println("cancel")
//                            
//                        case .Destructive:
//                            println("destructive")
//                        }
//                    }))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                }
//        }
        
        let headers = [
            "Content-Type":"application/json"
        ]
        
        var facebookName = ""
        var userId = ""
        var image = ""
        
        if let name = defaults.stringForKey("name"){
            facebookName = name
        }
        
        if let id = defaults.stringForKey("id"){
            userId = id
        }
        
        if let imageUrl = defaults.stringForKey("imageUrl"){
            image = imageUrl
        }
        
        var jsonBody = [
            "id":userId,
            "name": facebookName,
            "facebook":image
        ]
        
        
        // Use Alamofire to make POST request
        request(.POST, "http://52.3.178.99:3000/club/register/\(clubId)", parameters: [:], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = JSON(jsonBody).rawData()
            return (mutableRequest, nil)
        }), headers:headers)
            .responseString { [weak self] request, response, string, error in
                println(response)
        }

    }
    
    
    
    
}



    