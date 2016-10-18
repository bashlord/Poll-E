//
//  VC_login.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/4/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import UIKit

class VC_login: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signinTapped(sender: UIButton) {
        //Authentication
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        let code:NSString = txtCode.text!
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }

        if ( username.isEqualToString("") || password.isEqualToString("") || code.length == 0) {
            
            let alertView:UIAlertController = UIAlertController()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username/Password/Code"
            alertView.addAction(OKAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        } else {
            
            let post:NSString = "u=\(username)&p=\(password)&c=\(code)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string: base+log)!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error as NSError {
                reponseError = error
                urlData = nil
            }
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    //  var error: NSError?
                    
                    let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
                    
                    
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    
                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        NSLog("Login SUCCESS");
                        prefs.setValue(1, forKey: "loggedin")
                        prefs.setValue(jsonData.valueForKey("id") as! Int , forKey: "id")
                        if let p1 = jsonData.valueForKey("p1") as? Float{
                            prefs.setValue(p1, forKey: "w")
                        }else{
                            prefs.setValue(-1, forKey: "w")
                        }
                        if let p2 = jsonData.valueForKey("p2") as? Int{
                            prefs.setValue(p2, forKey: "age")
                        }else{
                            prefs.setValue(-1, forKey: "age")
                        }

                        if let p3 = jsonData.valueForKey("p3") as? Int{
                            prefs.setValue(p3, forKey: "hair")
                        }else{
                            prefs.setValue(-1, forKey: "hair")
                        }

                        if let p1 = jsonData.valueForKey("p4") as? Float{
                            prefs.setValue(p1, forKey: "h")
                        }else{
                            prefs.setValue(-1, forKey: "h")
                        }

                        if let p1 = jsonData.valueForKey("p5") as? Int{
                            prefs.setValue(p1, forKey: "gen")
                        }else{
                            prefs.setValue(-1, forKey: "gen")
                        }

                        if let p1 = jsonData.valueForKey("p6") as? Int{
                            prefs.setValue(p1, forKey: "eth")
                        }else{
                            prefs.setValue(-1, forKey: "eth")
                        }

                        if let p1 = jsonData.valueForKey("p7") as? Int{prefs.setValue(p1, forKey: "eye")
                        }else{
                            prefs.setValue(-1, forKey: "eye")
                        }

                        if let p1 = jsonData.valueForKey("p8") as? Int{prefs.setValue(p1, forKey: "r")
                        }else{
                            prefs.setValue(-1, forKey: "r")
                        }

                        if let p1 = jsonData.valueForKey("p9") as? Int{prefs.setValue(p1, forKey: "rel")
                        }else{
                            prefs.setValue(-1, forKey: "rel")
                        }
                        
                        
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        let alertView:UIAlertController = UIAlertController()
                        alertView.title = "Sign in Failed!"
                        alertView.message = "Incorrect User Login Info OR you have not registered yet!"
                        alertView.addAction(OKAction)
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                } else {
                    let alertView:UIAlertController = UIAlertController()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.addAction(OKAction)
                    self.presentViewController(alertView, animated: true, completion: nil)                }
            } else {
                let alertView:UIAlertController = UIAlertController()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
        
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
