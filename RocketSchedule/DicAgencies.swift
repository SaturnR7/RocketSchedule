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
           "RFSA":"RFSA(ロシア)",
           "CASC":"CASC(中国)",
           "ISRO":"ISRO(インド)",
           "USAF":"USAF(アメリカ)",
           "NASA":"NASA(アメリカ)",
           "JAXA":"JAXA(日本)",
           "SpX":"SPACEX(アメリカ)",
           "ASA":"アリアンスペース(欧州)"
          ]
    
    func getAgencyOfJapanese(key: String) -> String{
        
        let value = agencies[key]
        
        return value ?? "ー"
    }
}
