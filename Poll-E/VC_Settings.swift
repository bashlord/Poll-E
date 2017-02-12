//
//  VC_Settings.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/10/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import UIKit

class VC_Settings: UIViewController, UITextViewDelegate{
    let prefs:UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var txtSuggest: UITextView!
    @IBOutlet weak var bSuggest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSuggest.text = "Place a suggestion for a poll!"
        txtSuggest.textColor = UIColor.lightGray
        txtSuggest.selectedTextRange = txtSuggest.textRange(from: txtSuggest.beginningOfDocument, to: txtSuggest.beginningOfDocument)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VC_Settings.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let id = prefs.value(forKey: "id") as! Int
        //if id != 1{}
        //else{}
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSuggestion(_ sender: UIButton) {
        if (self.txtSuggest.text.characters.count != 0 || self.txtSuggest.text != "Place a suggestion for a poll!"){
            
            query_sugg(self.txtSuggest.text)
        
        }else{
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in}
            let alertView:UIAlertController = UIAlertController()
            alertView.title = "You didn't even suggest anything."
            alertView.message = "bruh"
            alertView.addAction(OKAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Place a suggestion for a poll!"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }

    func query_sugg(_ sugg:String){
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in}
        let id = prefs.integer(forKey: "id")
        let post:NSString = "p=\(sugg)&i=\(id)" as NSString
        NSLog("PostData: %@",post);
        let url:URL = URL(string: base+setting)!
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
                
                if(id == 1){
                    let jsonData:NSDictionary = (try! JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers )) as! NSDictionary
                    
                    
                    let fin:NSInteger = jsonData.value(forKey: "fin") as! NSInteger
                    
                    (UIApplication.shared.delegate as! AppDelegate).Q[fin] = Poll( q: sugg,id: fin,d: Date())
                    (UIApplication.shared.delegate as! AppDelegate).unanswered.append(fin)
                    
                }
                
                txtSuggest.text = "Place a suggestion for a poll!"
                txtSuggest.textColor = UIColor.lightGray
                
                txtSuggest.selectedTextRange = txtSuggest.textRange(from: txtSuggest.beginningOfDocument, to: txtSuggest.beginningOfDocument)
               
                
            } else {
                let alertView:UIAlertController = UIAlertController()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failed"
                alertView.addAction(OKAction)
                self.present(alertView, animated: true, completion: nil)                }
        }else {
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
    
    
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onLogout(_ sender: UIButton) {
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
        
        if let p1 = prefs.value(forKey: "w") as? Float{
            p11 = p1
        }
        if let p1 = prefs.value(forKey: "age") as? Int{
            p2 = p1
        }
        if let p1 = prefs.value(forKey: "hair") as? Int{
            p3 = p1
        }
        if let p1 = prefs.value(forKey: "h") as? Float{
            p4 = p1
        }
        if let p1 = prefs.value(forKey: "gen") as? Int{
            p5 = p1
        }
        if let p1 = prefs.value(forKey: "eth") as? Int{
            p6 = p1
        }
        if let p1 = prefs.value(forKey: "eye") as? Int{
            p7 = p1
        }
        if let p1 = prefs.value(forKey: "r") as? Int{
            p8 = p1
        }
        if let p1 = prefs.value(forKey: "rel") as? Int{
            p9 = p1
        }
        logoutQuery(p11, p2: p2, p3: p3, p4: p4, p5: p5, p6: p6, p7: p7, p8: p8, p9: p9)
    }
    
    func logoutQuery(_ p1:Float, p2:Int, p3:Int, p4:Float, p5:Int, p6:Int, p7:Int, p8:Int, p9:Int){
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        let id = prefs.value(forKey: "id") as! Int
        print(id)
        let post:NSString = "id=\(id)&w=\(p1)&age=\(p2)&hair=\(p3)&h=\(p4)&gen=\(p5)&eth=\(p6)&eye=\(p7)&r=\(p8)&ret=\(p9)" as NSString
        
        NSLog("PostData: %@",post);
        
        let url:URL = URL(string: "http://www.jjkbashlord.com/poll/logout.php")!
        
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
                
                let prefs:UserDefaults = UserDefaults.standard
                
                prefs.removePersistentDomain(forName: "com.bashlord.Poll-E")
                self.dismiss(animated: true, completion: nil)
                
            } else {
                let alertView:UIAlertController = UIAlertController()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failed"
                alertView.addAction(OKAction)
                self.present(alertView, animated: true, completion: nil)                }
        }else {
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
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
