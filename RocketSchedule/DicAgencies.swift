//
//  DicAgencies.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/07/30.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

// ラベル表示用の機関名構造体
struct DicAgencies {
    
    // 機関名を追加した場合は、「SearchRoketViewController.swift」-
    // 「func makeAgenciesDictionary」の機関名配列も同様に追加する。
    // [String(abbrev),String(表示用名称)]
    private let agencies: [String:String]
        = [
           "VKO":"ロシア宇宙軍",
           "RFSA":"ロスコスモス(ロシア)",
           "CASC":"中国航天科技集団",
           "ISRO":"インド宇宙研究機関",
           "USAF":"アメリカ空軍",
           "NASA":"NASA(アメリカ航空宇宙局)",
           "JAXA":"JAXA(宇宙航空研究開発機構)",
           "SpX":"SPACEX(アメリカ)",
           "ASA":"アリアンスペース(欧州)",
           "NASDA":"NASDA(宇宙開発事業団[現JAXA])",
           "RL":"Rocket Lab(アメリカ)",
           "NRO":"NRO(アメリカ国家偵察局)"
          ]
    
    func getAgencyOfJapanese(key: String) -> String{
        
        let value = agencies[key]
        
//        return value ?? "ー"
        return value ?? ""
    }
}
