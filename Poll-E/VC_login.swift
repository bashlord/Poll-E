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
    
    
    @IBAction func signinTapped(_ sender: UIButton) {
        //Authentication
        let username:NSString = txtUsername.text! as NSString
        let password:NSString = txtPassword.text! as NSString
        let code:NSString = txtCode.text! as NSString
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }

        if ( username.isEqual(to: "") || password.isEqual(to: "") || code.length == 0) {
            
            let alertView:UIAlertController = UIAlertController()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username/Password/Code"
            alertView.addAction(OKAction)
            self.present(alertView, animated: true, completion: nil)
        } else {
            
            let post:NSString = "u=\(username)&p=\(password)&c=\(code)" as NSString
            
            NSLog("PostData: %@",post);
            
            let url:URL = URL(string: base+log)!
            
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
                        prefs.setValue(jsonData.value(forKey: "id") as! Int , forKey: "id")
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
                        
                        
                        
                        self.dismiss(animated: true, completion: nil)
                        
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
