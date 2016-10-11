//
//  VC_Settings.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/10/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import UIKit

class VC_Settings: UIViewController {
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var txtSuggest: UITextView!
    @IBOutlet weak var bSuggest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let id = prefs.valueForKey("id") as! Int
        if id != 1{
            txtSuggest.removeFromSuperview()
            bSuggest.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onBackPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onLogout(sender: UIButton) {
        logcheck()
    
    }
    
    func logcheck(){
        var p11:Float = -1
        var p2 = -1
        var p3 = -1
        var p4:Float = -1.0
        var p5 = -1
        var p6 = -1
        var p7 = -1
        var p8 = -1
        var p9 = -1
        
        if let p1 = prefs.valueForKey("w") as? Float{
            p11 = p1
        }
        if let p1 = prefs.valueForKey("age") as? Int{
            p2 = p1
        }
        
        if let p1 = prefs.valueForKey("hair") as? Int{
            p3 = p1
        }
        
        if let p1 = prefs.valueForKey("h") as? Float{
            p4 = p1
        }
        
        if let p1 = prefs.valueForKey("gen") as? Int{
            p5 = p1
        }
        
        if let p1 = prefs.valueForKey("eth") as? Int{
            p6 = p1
        }
        
        if let p1 = prefs.valueForKey("eye") as? Int{
            p7 = p1
        }
        
        if let p1 = prefs.valueForKey("r") as? Int{
            p8 = p1
        }
        
        if let p1 = prefs.valueForKey("rel") as? Int{
            p9 = p1
        }
        logoutQuery(p11, p2: p2, p3: p3, p4: p4, p5: p5, p6: p6, p7: p7, p8: p8, p9: p9)
        
    }
    
    func logoutQuery(p1:Float, p2:Int, p3:Int, p4:Float, p5:Int, p6:Int, p7:Int, p8:Int, p9:Int){
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        
        let id = prefs.valueForKey("id") as! Int
        print(id)
        let post:NSString = "id=\(id)&w=\(p1)&age=\(p2)&hair=\(p3)&h=\(p4)&gen=\(p5)&eth=\(p6)&eye=\(p7)&r=\(p8)&ret=\(p9)"
        
        NSLog("PostData: %@",post);
        
        let url:NSURL = NSURL(string: "http://www.jjkbashlord.com/poll/logout.php")!
        
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
                
                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                prefs.removePersistentDomainForName("com.bashlord.Poll-E")
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                let alertView:UIAlertController = UIAlertController()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failed"
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)                }
        }else {
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
