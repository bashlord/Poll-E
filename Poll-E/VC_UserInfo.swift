//
//  VC_UserInfo.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/5/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import UIKit

class VC_UserInfo: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    var ages = [Int]()
    var genders = ["Pick!","Male", "Female", "Other"]
    var r_status = ["Please select!","Single", "Taken", "Complicated", "Married", "Other"]
    var races = ["Please select!", "Asian American","Black/African American", "Native American/Alaska Native",  "Native Hawaiian/Other Pacific Islander", "White American","Other"]
    
    var religions = ["Pick one!","Judaism", "Christianity", "Islam", "Bahá'í", "Hinduism", "Taoism", "Buddhism", "Sikhism", "Wicca", "Kemetism", "Hellenism", "Agnostic", "Other"]
    var colorsh = ["Red", "Brown", "Black", "Blond", "Grey", "Purple", "Green","Blue","Other"]
    var colorse = ["Red", "Brown", "Black", "Blond", "Grey", "Purple", "Green","Blue","Other"]
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var age_picker: UIPickerView!
    @IBOutlet weak var racepicker: UIPickerView!
    @IBOutlet weak var relationshippicker: UIPickerView!
    @IBOutlet weak var genderpicker: UIPickerView!
    @IBOutlet weak var religionpicker: UIPickerView!
    
    @IBOutlet weak var h_colorpicker: UIPickerView!
    @IBOutlet weak var e_colorpicker: UIPickerView!
    
    @IBOutlet weak var heightslider: UISlider!
    @IBOutlet weak var weightslider: UISlider!
    
    @IBOutlet weak var txtheight: UITextField!
    @IBOutlet weak var txtweight: UITextField!
    var p11:Float = -1
    var p2 = -1
    var p3 = -1
    var p4:Float = -1.0
    var p5 = -1
    var p6 = -1
    var p7 = -1
    var p8 = -1
    var p9 = -1
    var count = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        populate()
        
        print("fjnwelwnelkvm")
        if let p1 = prefs.valueForKey("w") as? Float{
            p11 = p1
            weightslider.setValue(p1, animated: true)
            if p1 == 300{
                self.txtweight.text = String(p1)+"+"
            }else{
                self.txtweight.text = String(round(p1))+" lbs"
            }
        }
        if let p1 = prefs.valueForKey("age") as? Int{
            p2 = p1
            age_picker.selectRow(p1, inComponent: 0, animated: true)
        }
        
        if let p1 = prefs.valueForKey("hair") as? Int{
            p3 = p1
            h_colorpicker.selectRow(p1, inComponent: 0, animated: true)
        }
        
        if let p1 = prefs.valueForKey("h") as? Float{
            p4 = p1
            heightslider.setValue(p1, animated: true)
            if p1 == 300{
                self.txtheight.text = String(p1)+"+"
            }else{
                self.txtheight.text = String(round(p1))+" lbs"
            }
        }
        
        if let p1 = prefs.valueForKey("gen") as? Int{
            p5 = p1
            genderpicker.selectRow(p1, inComponent: 0, animated: true)

        }
        
        if let p1 = prefs.valueForKey("eth") as? Int{
            p6 = p1
            racepicker.selectRow(p1, inComponent: 0, animated: true)

        }
        
        if let p1 = prefs.valueForKey("eye") as? Int{
            p7 = p1
            e_colorpicker.selectRow(p1, inComponent: 0, animated: true)
        }
        
        if let p1 = prefs.valueForKey("r") as? Int{
            p8 = p1
            religionpicker.selectRow(p1, inComponent: 0, animated: true)
        }
        
        if let p1 = prefs.valueForKey("rel") as? Int{
            p9 = p1
            relationshippicker.selectRow(p1, inComponent: 0, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == age_picker{
            return self.ages.count
        }else if pickerView == self.genderpicker{
            return self.genders.count
        }else if pickerView == self.racepicker{
            return self.races.count
        }else if pickerView == religionpicker{
            return self.religions.count
        }else if pickerView == h_colorpicker{
            return self.colorsh.count
        }else if pickerView == e_colorpicker{
            return self.colorse.count
        }else{
            return r_status.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if pickerView == age_picker{
            return String(self.ages[row])
        }else if pickerView == self.genderpicker{
            return self.genders[row]
        }else if pickerView == self.racepicker{
            return self.races[row]
        }else if pickerView == religionpicker{
            return self.religions[row]
        }else if pickerView == h_colorpicker{
            return self.colorsh[row]
        }else if pickerView == e_colorpicker{
            return self.colorse[row]
        }else{
            return self.r_status[row]
        }
    }
    
    
    @IBAction func heightslide(sender: UISlider) {
        let ft = Int(sender.value/12)
        let inch = Int(sender.value%12)
        self.txtheight.text = String(ft)+"'"+String(inch)+"\""
    }
    
    @IBAction func weightslide(sender: UISlider) {
        if sender.value == 300{
            self.txtweight.text = String(sender.value)+"+"
        }else{
            self.txtweight.text = String(round(sender.value))+" lbs"
        }
    }
    
    
    
    @IBAction func onBackPressed(sender: UIButton) {
        let i = prefs.integerForKey("id")
        let postp = update_binfo(i)
        if count > 0{
            query_binfo(postp)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func update_binfo(id:Int) -> String{
        var retstring:String = "id=\(id)"
        if( p11 != self.weightslider.value){
            retstring += "&p1=\(self.weightslider.value)"
            count += 1
            prefs.setFloat(self.weightslider.value, forKey: "w")
        }
        if(p2 != self.age_picker.selectedRowInComponent(0)){
            retstring += "&p2=\(self.age_picker.selectedRowInComponent(0))"
            count += 1
            prefs.setInteger(self.age_picker.selectedRowInComponent(0), forKey: "age")
        }
        if( p3 != self.h_colorpicker.selectedRowInComponent(0)){
            retstring += "&p3=\(self.h_colorpicker.selectedRowInComponent(0))"
            count += 1
            prefs.setInteger(self.h_colorpicker.selectedRowInComponent(0), forKey: "hair")
        }
        if( p4 != self.heightslider.value){
            retstring += "&p4=\(self.heightslider.value)"
            count += 1
            prefs.setFloat(self.heightslider.value, forKey: "h")
        }
        if( p5 != self.genderpicker.selectedRowInComponent(0)){
            retstring += "&p5=\(self.genderpicker.selectedRowInComponent(0))"
            count += 1
            prefs.setInteger(self.genderpicker.selectedRowInComponent(0), forKey: "gen")
        }
        if(p6 != self.racepicker.selectedRowInComponent(0)){
            retstring += "&p6=\(self.racepicker.selectedRowInComponent(0))"
            count += 1
            prefs.setInteger(self.racepicker.selectedRowInComponent(0), forKey: "eth")
        }
        if(p7 != self.e_colorpicker.selectedRowInComponent(0)){
            retstring += "&p7=\(self.e_colorpicker.selectedRowInComponent(0))"
            count += 1
            prefs.setInteger(self.e_colorpicker.selectedRowInComponent(0), forKey: "eye")
        }
        if(p8 != self.relationshippicker.selectedRowInComponent(0)){
            retstring += "&p8=\(self.relationshippicker.selectedRowInComponent(0))"
            count += 1
            prefs.setInteger(self.relationshippicker.selectedRowInComponent(0), forKey: "r")
        }
        if(p9 != self.religionpicker.selectedRowInComponent(0)){
            retstring += "&p9=\(self.religionpicker.selectedRowInComponent(0))"
            count += 1
            prefs.setInteger(self.religionpicker.selectedRowInComponent(0), forKey: "rel")
        }

        return retstring
    }
    
    func query_binfo(postp:String){
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }

        let post = postp as NSString
        NSLog("PostData: %@",post);
        print(post)

        let url:NSURL = NSURL(string: base+uinfo)!
        
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
    
    func populate(){
        if(self.ages.count == 0){
            for(var i = 1; i < 120; i++){
                self.ages.append(i);
            }
        }
    }
    
    
    
}
