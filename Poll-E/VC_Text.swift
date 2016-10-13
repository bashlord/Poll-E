//
//  VC_Text.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/13/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import UIKit

class VC_Text: UIViewController {

    @IBOutlet weak var text: UILabel!
    
    var msg:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        text.text = msg
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
