//
//  ViewController.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/3/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import UIKit

class VC_Root: UIViewController {
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    //let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
    //prefs.setObject(NSDate(), forKey: name)
    var logpage:VC_login!
    var uinfo:VC_UserInfo!
    var settings:VC_Settings!
    var pollflag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let logged = prefs.integerForKey("loggedin") as? Int{
            if logged == 0{
                logpage = self.storyboard?.instantiateViewControllerWithIdentifier("login")  as? VC_login
                self.presentViewController(logpage, animated: true, completion: nil)
            }else{
                setup()
            }
        }else{
            prefs.setInteger(0, forKey: "loggedin")
            logpage = self.storyboard?.instantiateViewControllerWithIdentifier("login")  as? VC_login
            self.presentViewController(logpage, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func on_UserInfo(sender: UIButton) {
        self.uinfo = self.storyboard?.instantiateViewControllerWithIdentifier("uinfo") as? VC_UserInfo
        self.presentViewController(self.uinfo, animated: true, completion: nil)
        
    }
    
    
    @IBAction func onSettings(sender: UIButton) {
        self.settings = self.storyboard?.instantiateViewControllerWithIdentifier("settings") as? VC_Settings
        self.presentViewController(self.settings, animated: true, completion: nil)
        
    }
    
    func setup(){
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        var id = -1
        if let iid = prefs.valueForKey("id") as? Int{
            id = iid
            print(id)
            let post:NSString = "id=\(id)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string: "http://www.jjkbashlord.com/poll/onlogged.php")!
            
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
        }else{
            logpage = self.storyboard?.instantiateViewControllerWithIdentifier("login")  as? VC_login
            self.presentViewController(logpage, animated: true, completion: nil)

        }
        
    }
    
}




