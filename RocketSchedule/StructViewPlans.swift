//
//  StructViewPlans.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/04/24.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

struct StructViewPlans {
    
    var id:Int
    var launchDate:Date
    var rocketName:String
    
    init(id: Int, launchData: Date, rocketName: String){
        self.id = id
        self.launchDate = launchData
        self.rocketName = rocketName
    }
    
}
