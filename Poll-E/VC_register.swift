//
//  VC_register.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/4/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//
import Foundation
import UIKit
import CoreTelephony

class VC_register: UIViewController {

    let testing = 1
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPhonenumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var verification_code: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func send_verifycode(_ sender: UIButton) {
        if(!txtPhonenumber.text!.isEmpty || txtPhonenumber!.text!.characters.count == 10 ){
            let networkInfo = CTTelephonyNetworkInfo()
            let carrier = networkInfo.subscriberCellularProvider
            if(testing == 1){
        // Get carrier name
                let carrierName = "@vtext.com"
                print(carrierName)
                req_code("2136639209", carrier: carrierName as NSString)
                
            }else{
                let carrierName = carrier!.carrierName
                print(carrierName)
            }
        }else{
            let alert = UIAlertController(title: "Default Style", message: "A standard alert.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default){ (action) in
                    //self.dismissViewControllerAnimated(true, completion: nil)
                }
)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func signupTapped(_ sender: AnyObject) {
        let username:NSString = txtUsername.text! as NSString
        let password:NSString = txtPassword.text! as NSString
        let phone:NSString = txtPhonenumber.text! as NSString
        let access:NSString = verification_code.text! as NSString
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        if ( username.isEqual(to: "") || password.isEqual(to: "") ) {
            
            let alertView:UIAlertController = UIAlertController()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.addAction(OKAction)
            self.present(alertView, animated: true, completion: nil)
        } else if ( access.isEqual(to: "") ) {
            
            let alertView:UIAlertController = UIAlertController()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter verification code."
            alertView.addAction(OKAction)
            self.present(alertView, animated: true, completion: nil)
        } else {
            /*
            $username = $_POST['username'];
            $a_code = $_POST['a_code'];
            $password = $_POST['password'];
            $pn = $_POST['phone'];
            */
            let post:NSString = "username=\(username)&password=\(password)&a_code=\(access)&phone=\(phone)" as NSString
            
            NSLog("PostData: %@",post);
            
            let url:URL = URL(string: base+sign)!
            
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
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                    
                    
                    let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        NSLog("Sign Up SUCCESS");
                        let alertView:UIAlertController = UIAlertController()
                        alertView.title = "Account Created!"
                        alertView.message = "Your account has now been verified!"
                        alertView.addAction(OKAction)
                        self.present(alertView, animated: true, completion: nil)
                        
                        self.dismiss(animated: true, completion: nil)
                    } else if(success == 0){
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        let alertView:UIAlertController = UIAlertController()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg as String
                        alertView.addAction(OKAction)
                        self.present(alertView, animated: true, completion: nil)
                        
                    }else if(success == 2){
                        let alertView:UIAlertController = UIAlertController()
                        alertView.title = "Authentication code needed!"
                        alertView.message = "Records do not show a code sent!"
                        alertView.addAction(OKAction)
                        self.present(alertView, animated: true, completion: nil)
                    }
                    else if(success == 3){
                        let alertView:UIAlertController = UIAlertController()
                        alertView.title = "Phone number already in use!"
                        alertView.message = "The number input is already registered!"
                        alertView.addAction(OKAction)
                        self.present(alertView, animated: true, completion: nil)
                    }
                    
                } else {
                    let alertView:UIAlertController = UIAlertController()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.addAction(OKAction)
                    self.present(alertView, animated: true, completion: nil)
                }
            }  else {
                let alertView:UIAlertController = UIAlertController()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.addAction(OKAction)
                self.present(alertView, animated: true, completion: nil)            }
        }
        
    }
    
    @IBAction func gotoLogin(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func req_code(_ phonenumber:NSString, carrier: NSString){
        let post:NSString = "pn=\(phonenumber)&carrier=\(carrier)" as NSString
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in}
        NSLog("PostData: %@",post);
        
        let url:URL = URL(string: "http://www.jjkbashlord.com/poll/accesscode.php")!
        
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
                
                var error: NSError?
                
                let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                
                
                let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
                
                //[jsonData[@"success"] integerValue];
                
                NSLog("Success: %ld", success);
                
                if(success == 1)
                {
                    NSLog("Sign Up SUCCESS");
                    
                } else {
                    var error_msg:NSString
                    
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    let alertView:UIAlertController = UIAlertController()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = error_msg as String
                    alertView.addAction(OKAction)
                    self.present(alertView, animated: true, completion: nil)
                    
                }
                
            } else {
                let alertView:UIAlertController = UIAlertController()
                alertView.title = "Sign Up Failed!"
                alertView.message = "Connection Failed"
                alertView.addAction(OKAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }  else {
            let alertView:UIAlertController = UIAlertController()
            alertView.title = "Sign in Failed!"
            alertView.message = "Connection Failure"
            if let error = reponseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.addAction(OKAction)
            self.present(alertView, animated: true, completion: nil)            }
    }
}

