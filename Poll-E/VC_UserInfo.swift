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
    var genders = ["Male", "Female", "Other"]
    
    @IBOutlet weak var age_picker: UIPickerView!
    
    @IBOutlet weak var genderpicker: UIPickerView!
    
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
        }else{
            return self.genders.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if pickerView == age_picker{
            return String(self.ages[row])
        }else{
            return self.genders[row]
        }
        
    }
    
    func populate(){
        if(self.ages.count == 0){
            for(var i = 0; i < 120; i++){
                self.ages.append(i);
            }
        }
    }
    
    
}
