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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let logged = prefs.integerForKey("loggedin") as? Int{
            if logged == 0{
                logpage = self.storyboard?.instantiateViewControllerWithIdentifier("login")  as? VC_login
                self.presentViewController(logpage, animated: true, completion: nil)
            }
        }else{
            prefs.setInteger(0, forKey: "loggedin")
            self.presentViewController(logpage, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

