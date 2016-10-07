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
    
    @IBOutlet weak var age_picker: UIPickerView!
    @IBOutlet weak var racepicker: UIPickerView!
    @IBOutlet weak var relationshippicker: UIPickerView!
    @IBOutlet weak var genderpicker: UIPickerView!
    @IBOutlet weak var religionpicker: UIPickerView!
    
    
    @IBOutlet weak var heightslider: UISlider!
    @IBOutlet weak var weightslider: UISlider!
    
    @IBOutlet weak var txtheight: UITextField!
    @IBOutlet weak var txtweight: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        populate()
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
    
    
    func populate(){
        if(self.ages.count == 0){
            for(var i = 1; i < 120; i++){
                self.ages.append(i);
            }
        }
    }
    
    
}
