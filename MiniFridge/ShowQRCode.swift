//
//  ShowQRCode.swift
//  MiniFridge
//
//  Created by Tony Winters on 8/29/15.
//  Copyright (c) 2015 CheesyCloud. All rights reserved.
//

class ShowQRCode: UIViewController {
    
    var qrcodeImage: CIImage!
    
    @IBOutlet weak var clubTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    let defaults = NSUserDefaults.standardUserDefaults()
    var club:Club!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let data = club.id.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter.outputImage
        
        displayQRCodeImage()
        clubTitle.text = club.name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQRCodeImage() {
        let scaleX = imageView.frame.size.width / qrcodeImage.extent().size.width
        let scaleY = imageView.frame.size.height / qrcodeImage.extent().size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        imageView.image = UIImage(CIImage: transformedImage)
        
        
    }
}