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
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    var pollpageviewer: PVC_PollViews? {
        didSet {
            //pollpageviewer?.pvc_delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pollpageviewer = self.storyboard?.instantiateViewControllerWithIdentifier("PVC_PollViews") as! PVC_PollViews
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let logged = prefs.integerForKey("loggedin") as? Int{
            if logged == 0{
                //user is not logged in
                logpage = self.storyboard?.instantiateViewControllerWithIdentifier("login")  as? VC_login
                self.presentViewController(logpage, animated: true, completion: nil)
            }else{
                //HERE IS WHERE A SUCCESSFUL LOGIN/LOGGED IN HAPPENS
                
                setup()
                self.view.addSubview((pollpageviewer?.view)!)
                self.view.sendSubviewToBack((pollpageviewer?.view)!)
                
            }
        }else{
            //user has not logged in
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
    
    
    @IBAction func onNext(sender: UIButton) {
        self.pollpageviewer?.scrollToNextViewController()
    }
    
    @IBAction func onPrev(sender: UIButton) {
        self.pollpageviewer?.scrollToPrevViewController()
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
                        
                        let qs:NSArray = jsonData.valueForKey("qs") as! NSArray
                        let ans:NSArray = jsonData.valueForKey("ans") as! NSArray
                        
                        var anscount = 0
                        for(var i = 0; i < qs.count; i++){
                            let qid = qs[i].valueForKey("id") as! Int
                            let q = qs[i].valueForKey("que") as! String
                            let qt = string_to_date(qs[i].valueForKey("t") as! String)
                            
                            var p = -1
                            if anscount < ans.count{
                                p = ans[anscount].valueForKey("qid") as! Int
                            }
                            
                            let tpoll = Poll( q: q,id: qid, d: qt)
                            if qid == p{
                                tpoll.resp = ans[anscount].valueForKey("r") as! Int
                                tpoll.rtime = string_to_date(ans[anscount].valueForKey("t") as! String)
                                (UIApplication.sharedApplication().delegate as! AppDelegate).answered.append(i)
                                anscount++
                            }
                            else{
                                (UIApplication.sharedApplication().delegate as! AppDelegate).unanswered.append(i)
                            }
                            
                            (UIApplication.sharedApplication().delegate as! AppDelegate).Q[i] = tpoll
                        }
                        
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
    
    func string_to_date(time:String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-DD HH:mm:ss"
        //formatter.locale = NSLocale.currentLocale()
        let dateString = formatter.dateFromString(time)
        
        return dateString!
    }
}

