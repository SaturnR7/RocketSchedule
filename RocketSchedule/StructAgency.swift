//
//  StructNotificationDate.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/04/13.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

struct StructAgency : Codable{
    
    var agencies: [Content]
    var total: Int
    var count: Int
    var offset: Int

    struct Content: Codable {

        var id: Int
        var name: String
        var abbrev: String
        var type: Int
        var countryCode: String
        var wikiURL: String?
        var infoURL: String?
        var infoURLs: [String]?
        var islsp: Int?
        var changed: String?

    }
    
}
