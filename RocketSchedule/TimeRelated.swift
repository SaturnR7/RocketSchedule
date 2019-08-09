//
//  DicTimeZone.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/08/06.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

// TimeRelated.swiftを使った処理だが不要となった
class TimeRelated {

    private let timeZoneAbb: [String:Int]
        = [
            "GMT+12":12,
            "GMT+11":11,
            "GMT+10":10,
            "GMT+9":9,
            "GMT+8":8,
            "GMT+7":7,
            "GMT+6":6,
            "GMT+5":5,
            "GMT+4":4,
            "GMT+3":3,
            "GMT+2":2,
            "GMT+1":1,
            "GMT+0":0,
            "GMT-0":-0,
            "GMT-1":-1,
            "GMT-2":-2,
            "GMT-3":-3,
            "GMT-4":-4,
            "GMT-5":-5,
            "GMT-6":-6,
            "GMT-7":-7,
            "GMT-8":-8,
            "GMT-9":-9,
            "GMT-10":-10,
            "GMT-11":-11,
            "GMT-12":-12
          ]

    // UTCまたはGMTから現在のタイムゾーンまでの時差（時間）をInt型で返す。
    // タイムゾーンを東京に設定している場合、「GMT+9」なのでInt型で「9」を返す。
    func getGmtValue() -> Int{
        
        let abbreviation = TimeZone.current.abbreviation()

        print("TimeRelated - getGmtValue - abbreviation: \(abbreviation)")
        
        if let abbreviation = abbreviation{
            return timeZoneAbb[abbreviation] ?? 0
        }else{
            return 0 // UTC
        }
    }
    
    // GMTの時差を元にTimeinterval用のDouble値を返す。
    // Usage: let date = Date(timeInterval: 60*60*9*1, since: dateString)
    func getTimeintervalValue(gmtValue value: Int) -> Double {
            return Double(60*60*value*1)
    }
 }
