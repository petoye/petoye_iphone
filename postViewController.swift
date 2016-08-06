//
//  postViewController.swift
//  PetOye
//
//  Created by Ameya Vichare on 06/08/16.
//  Copyright © 2016 Ameya Vichare. All rights reserved.
//

import UIKit

class postViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var hack: UITextView!
    @IBOutlet weak var cancel: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hack.becomeFirstResponder()
        
        let customView = UIView(frame: CGRectMake(0, 0, 10, 50))
        customView.backgroundColor = UIColorFromHex(0xF7F7F7,alpha: 1)
        
        
        var button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "camera_button.png"), forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(postViewController.importImage(_:)), forControlEvents: .TouchUpInside)
        button.frame = CGRect(x: 20, y: 15, width: 23, height: 20)
        
        var button1 = UIButton(type: .Custom)
        button1.setImage(UIImage(named: "post_button.png"), forState: UIControlState.Normal)
        button1.addTarget(self, action: #selector(postViewController.upload(_:)), forControlEvents: .TouchUpInside)
        button1.frame = CGRect(x: self.view.frame.size.width - (self.view.frame.size.width * 0.225) - 5 , y: 12.5, width: self.view.frame.size.width * 0.225, height: 25)

        
        customView.addSubview(button)
        customView.addSubview(button1)
        message.inputAccessoryView = customView
        hack.inputAccessoryView = customView
        self.hideKeyboardWhenTappedAround()
        cancel.hidden = true
        
        
        //tap
        
        //var singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTapRecognized))
        //singleTap.numberOfTapsRequired = 1
        //message.addGestureRecognizer(singleTap)
        
        
        

    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        postImage.image = nil
        cancel.hidden = true
    }
    
    @IBAction func upload(sender: AnyObject) {
        
        if (postImage != nil && message != nil){
            
            
            ////////////
            
            
             let uid = 6 //userDefault.objectForKey("id")!
             let msg = message.text!
            
            
            let imageData = UIImagePNGRepresentation(postImage.image!)!
            //print(imageData)
            
             // add a comment api call
            
             let request = NSMutableURLRequest(URL: NSURL(string: "http://api.petoye.com/feeds/\(uid)/create")!)
             request.HTTPMethod = "POST"
             let postString = "message=\(msg)&image=\(imageData)"
             request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
             let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
             guard error == nil && data != nil else {                                                          // check for fundamental networking error
             print(error!)
             return
             }
             
             if let httpStat = response as? NSHTTPURLResponse where httpStat.statusCode == 201
             {
             //pop up comment added
             
             
             }
             
             
             if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 201 {           // check for http errors
             print("statusCode should be 201, but is \(httpStatus.statusCode)")
             print(response!)
             }
             
             var responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
             print(responseString!)
             
             
             }
             task.resume()
            

            
            
        }
        else {
            print("select image and type message please!")
        }
        
        
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print("image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        postImage.image = image
        hack.becomeFirstResponder()
        cancel.hidden = false
        
    }
    
    @IBAction func importImage(sender: AnyObject) {
        
        print("okay")
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
        
    }
    
    
  


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        message.text = ""
        
    }
    
    func textViewDidChange(textView: UITextView) {
       
    }
}