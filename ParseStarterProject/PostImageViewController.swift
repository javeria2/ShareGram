//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Sanchay  Javeria on 6/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

@available(iOS 8.0, *)
class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var msg: UITextField!
    
    func displayPopUp(title: String, message: String) {
        let popUp:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        popUp.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(popUp, animated: true, completion: nil)
    }
    
    @IBAction func choseImage(sender: AnyObject) {
    
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        img.allowsEditing = false
        self.presentViewController(img, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imagePost.image = image
    }
    
    func compressForUpload(original:UIImage, withHeightLimit heightLimit:CGFloat, andWidthLimit widthLimit:CGFloat)->UIImage{
        
        let originalSize = original.size
        var newSize = originalSize
        
        if originalSize.width > widthLimit && originalSize.width > originalSize.height {
            
            newSize.width = widthLimit
            newSize.height = originalSize.height*(widthLimit/originalSize.width)
        }else if originalSize.height > heightLimit && originalSize.height > originalSize.width {
            
            newSize.height = heightLimit
            newSize.width = originalSize.width*(heightLimit/originalSize.height)
        }
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize)
        original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return compressedImage
    }
    
    func isFileSizeUpTo10Mebibytes(fileSize: Int) -> Bool {
        
        return fileSize <= 10485760
        
    }
    
    @IBAction func postImage(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let post = PFObject(className: "Post")
        post["caption"] = msg.text
        post["userId"] = PFUser.currentUser()?.objectId!
        // Compress the image
        let compressedImage = compressForUpload(imagePost.image!, withHeightLimit: 1000, andWidthLimit: 1000)
        // Create image data from our image
        let imageData = UIImagePNGRepresentation(compressedImage)
        let fileNotTooBig = isFileSizeUpTo10Mebibytes(imageData!.length)
        if fileNotTooBig == true {
            // create an image file from the image data / name is arbitrary
            let imageFile = PFFile(name: "image.png", data: imageData!)
            post["imageFile"] = imageFile
            post.saveInBackgroundWithBlock { (success, error) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if error == nil {
                    self.displayPopUp("Success!", message: "Your image has been successfully posted.")
                    self.imagePost.image = nil
                    self.msg.text = ""
                } else {
            self.displayPopUp("Error!", message: "Could not post your image, try again later. \(error!.description)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
