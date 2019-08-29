//
//  DicCountryCode.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/08/29.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

struct DicCountryCode {
    
    private let countryCode: [String:String]
        = [
            "USA":"アメリカ",
            "RUS":"ロシア",
            "JPN":"日本",
            "GUF":"フランス",
            "FRA":"フランス",
            "CHN":"中国",
            "IND":"インド",
            "GBR":"イギリス",
            "KAZ":"ロシア",
            "DEU":"ドイツ",
            "CAN":"カナダ",
            "ITA":"イタリア",
            "ESP":"スペイン"
        ]
    
    func getAgencyOfJapanese(key: String) -> String{
        
        let value = countryCode[key]
        
        return value ?? "N/A"
    }
}
