//
//  File.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/10/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import Foundation

class Poll {
    var q:String!
    var id:Int!
    var resp:Int = -1
    var time:Date
    var rtime:Date!
    var isUna:Bool!
    var index:Int!
    
    init(q:String, id:Int, d:Date){
        self.q = q
        self.id = id
        self.time = d
    }
    
}
