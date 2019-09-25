//
//  DicTimeZone.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/09/25.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

struct DicTimeZone {
        
    private let abbreviationDictionary: [String:String]
        = [
//            "Asia/Kolkata"      : "IST" ,
//            "Asia/Tehran"       : "IRST",
//            "America/Chicago": "CST" ,
//            "America/New_York": "EST" ,
//            "UTC": "UTC" ,
//            "America/Halifax": "AST" ,
//            "America/St_Johns": "NST" ,
            "Asia/Tokyo": "JST"
//            "Asia/Dubai": "GST" ,
//            "Africa/Lagos": "WAT" ,
//            "Europe/Lisbon": "WEST",
//            "America/Sao_Paulo": "BRT" ,
//            "Europe/Lisbon": "WET" ,
//            "Europe/London": "BST" ,
//            "Europe/Paris": "CEST",
//            "Pacific/Auckland": "NZST",
//            "Asia/Dhaka": "BDT" ,
//            "Asia/Singapore": "SGT" ,
//            "America/Bogota": "COT" ,
//            "Asia/Jakarta": "WIT" ,
//            "America/Santiago": "CLT" ,
//            "Africa/Addis_Ababa": "EAT" ,
//            "Africa/Harare": "CAT" ,
//            "Europe/Moscow": "MSK" ,
//            "Europe/Paris": "CET" ,
//            "Asia/Seoul": "KST" ,
//            "Europe/Moscow": "MSD" ,
//            "America/Santiago": "CLST",
//            "Asia/Hong_Kong": "HKT" ,
//            "America/Juneau": "AKST",
//            "Asia/Karachi": "PKT" ,
//            "Asia/Bangkok": "ICT" ,
//            "Europe/Istanbul": "TRT" ,
//            "GMT": "GMT" ,
//            "Europe/Athens": "EET" ,
//            "America/Los_Angeles": "PST" ,
//            "Europe/Athens": "EEST",
//            "America/Argentina/Buenos_Aires": "ART" ,
//            "America/Phoenix": "MST" ,
//            "Asia/Manila": "PHT" ,
//            "America/Lima": "PET" ,
//            "Pacific/Honolulu": "HST" ,
            
            // サマータイム
//            "America/Sao_Paulo" : "BRST",
//            "America/Denver": "MDT" ,
//            "Pacific/Auckland": "NZDT",
//            "America/Chicago": "CDT" ,
//            "America/Halifax": "ADT" ,
//            "America/New_York": "EDT" ,
//            "America/Los_Angeles": "PDT" ,
//            "America/St_Johns": "NDT" ,
//            "America/Juneau":"AKDT"
            ]
    
    func getTimezoneAbbreviation(key: String) -> String{
        
        let value = abbreviationDictionary[key]
        
        return value ?? "Local Time"
    }

}
