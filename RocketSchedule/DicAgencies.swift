//
//  DicAgencies.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/07/30.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

struct DicAgencies {
    
    private let agencies: [String:String]
        = [
           "VKO":"VKO(ロシア)",
           "NASA":"NASA(アメリカ)",
           "JAXA":"JAXA(日本)",
           "SpX":"SPACEX(アメリカ)"
          ]
    
    func getAgencyOfJapanese(key: String) -> String{
        
        let value = agencies[key]
        
        return value ?? "N/A"
    }
}
