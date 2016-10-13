//
//  VC_Question.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/10/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import UIKit

class VC_Question: UIViewController {
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var b_no: UIButton!
    @IBOutlet weak var b_yes: UIButton!
    var poll:Poll!
    @IBOutlet weak var question: UILabel!
    
    var unans_index:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let p = poll{
            self.question.text = poll.q
            if poll.resp != -1{
                if poll.resp == 0{
                    self.b_no.selected = true
                     self.question.textColor = UIColor.grayColor()
                }else{
                    self.b_yes.selected = true
                     self.question.textColor = UIColor.grayColor()
                }
            }
        }
    }
   
    //set flag to answered if not already
    //move it from the unanswered->answered array in appdelegate
    //change the value of the answered flag as well as the response in Q
    //send query
    @IBAction func onNo(sender: UIButton) {
        if self.poll.resp == 0{
            
        }else if query_resp(0, qid: self.poll.id) == true{
            if self.poll.resp == 1{
                self.b_yes.selected = false
            }
            self.poll.resp = 0
            (UIApplication.sharedApplication().delegate as! AppDelegate).Q[self.poll.id]?.resp = 0
            self.b_no.selected = true
            if self.poll.isUna == true{
                self.poll.isUna = false
                (UIApplication.sharedApplication().delegate as! AppDelegate).Q[self.poll.id]?.isUna = false
                (UIApplication.sharedApplication().delegate as! AppDelegate).unanswered.removeAtIndex(self.unans_index)
                (UIApplication.sharedApplication().delegate as! AppDelegate).answered.append(self.unans_index)
               self.question.textColor = UIColor.grayColor()
            }
        }
    }
    
    @IBAction func onYes(sender: UIButton) {
        if self.poll.resp == 1{
            
        }else if query_resp(1, qid: self.poll.id) == true{
            if self.poll.resp == 0{
                self.b_no.selected = false
            }
            self.poll.resp = 1
             self.b_yes.selected = true
            (UIApplication.sharedApplication().delegate as! AppDelegate).Q[self.poll.id]?.resp = 1
            if self.poll.isUna == true{
                self.poll.isUna = false
                (UIApplication.sharedApplication().delegate as! AppDelegate).Q[self.poll.id]?.isUna = false
                (UIApplication.sharedApplication().delegate as! AppDelegate).unanswered.removeAtIndex(self.unans_index)
                (UIApplication.sharedApplication().delegate as! AppDelegate).answered.append(self.unans_index)
                self.question.textColor = UIColor.grayColor()
            }
        }
    }
    
    func query_resp(resp:Int, qid:Int) -> Bool{
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in}
        
        let id = prefs.valueForKey("id") as! Int
        print(id)
        let post:NSString = "u=\(id)&q=\(qid)&r=\(resp)"
        NSLog("PostData: %@",post);
        let url:NSURL = NSURL(string: "http://www.jjkbashlord.com/poll/on_resp_update.php")!
        
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
                
                
                let r:NSInteger = jsonData.valueForKey("p") as! NSInteger
                if r != 1{
                    let alertView:UIAlertController = UIAlertController()
                    alertView.title = "There was a problem!"
                    alertView.message = "Sorry, try again :("
                    alertView.addAction(OKAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                    return false
                }else{
                    return true
                }
                
                
            } else {
                let alertView:UIAlertController = UIAlertController()
                alertView.title = "Bad Connection!"
                alertView.message = "Connection Failed"
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)                }
        }else {
            let alertView:UIAlertController = UIAlertController()
            alertView.title = "Bad Connection!"
            alertView.message = "Connection Failure"
            if let error = reponseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.addAction(OKAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        return false
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
