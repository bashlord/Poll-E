//
//  ViewController.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/3/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import UIKit

class VC_Root: UIViewController {
    let prefs:UserDefaults = UserDefaults.standard
    //let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
    //prefs.setObject(NSDate(), forKey: name)
    var logpage:VC_login!
    var uinfo:VC_UserInfo!
    var settings:VC_Settings!
    var pollflag = 0
    @IBOutlet weak var segcontrol: UISegmentedControl!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    
    var pollpageviewer: PVC_PollViews? {
        didSet {
            //pollpageviewer?.pvc_delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pollpageviewer = self.storyboard?.instantiateViewController(withIdentifier: "PVC_PollViews") as! PVC_PollViews
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let logged = prefs.integer(forKey: "loggedin") as? Int{
            if logged == 0{
                //user is not logged in
                logpage = self.storyboard?.instantiateViewController(withIdentifier: "login")  as? VC_login
                self.present(logpage, animated: true, completion: nil)
            }else{
                //HERE IS WHERE A SUCCESSFUL LOGIN/LOGGED IN HAPPENS
                
                setup()
                self.view.addSubview((pollpageviewer?.view)!)
                self.view.sendSubview(toBack: (pollpageviewer?.view)!)
                
            }
        }else{
            //user has not logged in
            prefs.set(0, forKey: "loggedin")
            logpage = self.storyboard?.instantiateViewController(withIdentifier: "login")  as? VC_login
            self.present(logpage, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func on_UserInfo(_ sender: UIButton) {
        self.uinfo = self.storyboard?.instantiateViewController(withIdentifier: "uinfo") as? VC_UserInfo
        self.present(self.uinfo, animated: true, completion: nil)
        
    }
    
    
    @IBAction func onSettings(_ sender: UIButton) {
        self.settings = self.storyboard?.instantiateViewController(withIdentifier: "settings") as? VC_Settings
        self.present(self.settings, animated: true, completion: nil)
        
    }
    
    
    @IBAction func onNext(_ sender: UIButton) {
        self.pollpageviewer?.scrollToNextViewController()
    }
    
    @IBAction func onPrev(_ sender: UIButton) {
        self.pollpageviewer?.scrollToPrevViewController()
    }
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        switch segcontrol.selectedSegmentIndex
        {
        case 0:
            if self.pollpageviewer?.unansweredflag != 0{
                self.pollpageviewer?.unansweredflag = 0
                self.pollpageviewer?.togglePVC(0)
            }
        case 1:
            if self.pollpageviewer?.unansweredflag != 1{
                self.pollpageviewer?.unansweredflag = 1
                 self.pollpageviewer?.togglePVC(1)
            }
        case 2:
            if self.pollpageviewer?.unansweredflag != 2{
                self.pollpageviewer?.unansweredflag = 2
                 self.pollpageviewer?.togglePVC(2)
            }
        default:
            break; 
        }
    }
    
    
    
    
    func setup(){
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        var id = -1
        if let iid = prefs.value(forKey: "id") as? Int{
            id = iid
            print(id)
            let post:NSString = "id=\(id)" as NSString
            
            NSLog("PostData: %@",post);
            
            let url:URL = URL(string: base+root)!
            
            let postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
            
            let postLength:NSString = String( postData.count ) as NSString
            
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: URLResponse?
            
            var urlData: Data?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
            } catch let error as NSError {
                reponseError = error
                urlData = nil
            }
            
            if ( urlData != nil ) {
                let res = response as! HTTPURLResponse!;
                
                NSLog("Response code: %ld", res?.statusCode);
                
                if ((res?.statusCode)! >= 200 && (res?.statusCode)! < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:String.Encoding.utf8.rawValue)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    //  var error: NSError?
                    
                    let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                    
                    
                    let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
                    
                    let prefs:UserDefaults = UserDefaults.standard
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        NSLog("Login SUCCESS");
                        prefs.setValue(1, forKey: "loggedin")
                        if let p1 = jsonData.value(forKey: "p1") as? Float{
                            prefs.setValue(p1, forKey: "w")
                        }else{
                            prefs.setValue(-1, forKey: "w")
                        }
                        if let p2 = jsonData.value(forKey: "p2") as? Int{
                            prefs.setValue(p2, forKey: "age")
                        }else{
                            prefs.setValue(-1, forKey: "age")
                        }
                        
                        if let p3 = jsonData.value(forKey: "p3") as? Int{
                            prefs.setValue(p3, forKey: "hair")
                        }else{
                            prefs.setValue(-1, forKey: "hair")
                        }
                        
                        if let p1 = jsonData.value(forKey: "p4") as? Float{
                            prefs.setValue(p1, forKey: "h")
                        }else{
                            prefs.setValue(-1, forKey: "h")
                        }
                        
                        if let p1 = jsonData.value(forKey: "p5") as? Int{
                            prefs.setValue(p1, forKey: "gen")
                        }else{
                            prefs.setValue(-1, forKey: "gen")
                        }
                        
                        if let p1 = jsonData.value(forKey: "p6") as? Int{
                            prefs.setValue(p1, forKey: "eth")
                        }else{
                            prefs.setValue(-1, forKey: "eth")
                        }
                        
                        if let p1 = jsonData.value(forKey: "p7") as? Int{prefs.setValue(p1, forKey: "eye")
                        }else{
                            prefs.setValue(-1, forKey: "eye")
                        }
                        
                        if let p1 = jsonData.value(forKey: "p8") as? Int{prefs.setValue(p1, forKey: "r")
                        }else{
                            prefs.setValue(-1, forKey: "r")
                        }
                        
                        if let p1 = jsonData.value(forKey: "p9") as? Int{prefs.setValue(p1, forKey: "rel")
                        }else{
                            prefs.setValue(-1, forKey: "rel")
                        }
                        
                        let qs:NSArray = jsonData.value(forKey: "qs") as! NSArray
                        let ans:NSArray = jsonData.value(forKey: "ans") as! NSArray
                        
                        var anscount = 0
                        for(i in 0 ..< qs.count){
                            let qid = (qs[i] as AnyObject).value(forKey: "id") as! Int
                            let q = (qs[i] as AnyObject).value(forKey: "que") as! String
                            let qt = string_to_date((qs[i] as AnyObject).value(forKey: "t") as! String)
                            
                            var p = -1
                            if anscount < ans.count{
                                p = (ans[anscount] as AnyObject).value(forKey: "qid") as! Int
                            }
                            
                            let tpoll = Poll( q: q,id: qid, d: qt)
                            if qid == p{
                                tpoll.resp = ans[anscount].value(forKey: "r") as! Int
                                tpoll.rtime = string_to_date(ans[anscount].value(forKey: "t") as! String)
                                (UIApplication.shared.delegate as! AppDelegate).answered.append(i)
                                anscount += 1
                            }else{
                                (UIApplication.shared.delegate as! AppDelegate).unanswered.append(i)
                            }
                            
                            (UIApplication.shared.delegate as! AppDelegate).Q[i] = tpoll
                        }
                        
                    } else {
                        let alertView:UIAlertController = UIAlertController()
                        alertView.title = "Sign in Failed!"
                        alertView.message = "Incorrect User Login Info OR you have not registered yet!"
                        alertView.addAction(OKAction)
                        self.present(alertView, animated: true, completion: nil)
                    }
                } else {
                    let alertView:UIAlertController = UIAlertController()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.addAction(OKAction)
                    self.present(alertView, animated: true, completion: nil)                }
            } else {
                let alertView:UIAlertController = UIAlertController()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.addAction(OKAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }else{
            logpage = self.storyboard?.instantiateViewController(withIdentifier: "login")  as? VC_login
            self.present(logpage, animated: true, completion: nil)

        }
        
    }
    
    func string_to_date(_ time:String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-DD HH:mm:ss"
        //formatter.locale = NSLocale.currentLocale()
        let dateString = formatter.date(from: time)
        
        return dateString!
    }
}

