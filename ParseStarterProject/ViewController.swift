/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

@available(iOS 8.0, *)
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var register: UILabel!
    
    var loginMode = false
    
    func displayPopUp(title: String, message: String) {
        let popUp:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        popUp.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(popUp, animated: true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        var loading = UIActivityIndicatorView()
        var errorMsg = "Login failed, try again later."
        var user = PFUser()
        if username.text == "" || password.text == "" {
            displayPopUp("Error!", message: "Enter a valid username and password!")
            return
        }
        
        loading = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        loading.center = self.view.center
        loading.hidesWhenStopped = true
        loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        view.addSubview(loading)
        loading.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        if loginMode == false {
            user.username = username.text
            user.password = password.text
            user.signUpInBackgroundWithBlock { (hit, error) in
                loading.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error != nil {
                    if let error = error!.userInfo["error"] as? String {
                        errorMsg = error
                    }
                    self.displayPopUp("Error in signing in.", message: errorMsg)
                } else {
                    //signed in!
                    self.performSegueWithIdentifier("login", sender: self)
                }
            }
        } else {
            PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) in
                
                
                loading.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error != nil {
                    if let error = error!.userInfo["error"] as? String {
                        errorMsg = error
                    }
                    self.displayPopUp("Error in login.", message: errorMsg)
                } else {
                    //logged in!
                    self.performSegueWithIdentifier("login", sender: self)
                    
                }
            })
        }
        
    }
    
    @IBAction func login(sender: AnyObject) {
        if loginMode == false {
            signUpOutlet.titleLabel!.text = "Login"
            loginOutlet.setTitle("Sign up", forState: UIControlState.Normal)
            register.text = "Not registered?"
            loginMode = true
        } else if loginMode == true {
            signUpOutlet.titleLabel!.text = "Sign Up"
            loginOutlet.setTitle("Login", forState: UIControlState.Normal)
            register.text = "Already registered?"
            loginMode = false
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.objectId != nil {
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true) //this closes on pressing anywhere in the view
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() //this closes on hitting return
        return true
    }

    override func viewDidLoad() {
        self.username.delegate = self
        self.password.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
