//
//  StructRealmFavoriteData.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/07/04.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

struct StructRealmFavoriteData {
    
    var id: Int
    var rocketName: String
    var windowStart: String
    var windowEnd: String
    var videoURLs: [String]
    var launchDate: Date
    var agency: String
    var rocketImageURL: String
    var rocketImageUrlForCell: String
    var missionName: String
    var agencyInfoUrl: String

//    var id: Int = 0
//    var rocketName: String = ""
//    var windowStart: String = ""
//    var windowEnd: String = ""
//    var videoURL: String = ""

    init(id: Int,
         rocketName: String,
         windowsStart: String,
         windowEnd: String,
         videoURLs: [String],
         launchDate: Date,
         agency: String,
         rocketImageURL: String,
         rocketImageUrlForCell: String,
         missionName: String,
         agencyInfoUrl: String){
        
        self.id = id
        self.rocketName = rocketName
        self.windowStart = windowEnd
        self.windowEnd = windowEnd
        self.videoURLs = videoURLs
        self.launchDate = launchDate
        self.agency = agency
        self.rocketImageURL = rocketImageURL
        self.rocketImageUrlForCell = rocketImageUrlForCell
        self.missionName = missionName
        self.agencyInfoUrl = agencyInfoUrl
        
    }

//    var favoriteData: [Content]
//    var count: Int
//
//    struct Content {
//
//        var id: Int
//        var rocketName: String
//        var windowStart: String
//        var windowEnd: String
//        var videoURL: String
//
//        init(){
//            id = 0
//            rocketName = ""
//            windowStart = ""
//            windowEnd = ""
//            videoURL = ""
//        }
//
////        init(id: Int,
////             rocketName: String,
////             windowsStart: String,
////             windowEnd: String,
////             videoURL: String){
////            self.id = id
////            self.rocketName = rocketName
////            self.windowStart = windowEnd
////            self.windowEnd = windowEnd
////            self.videoURL = videoURL
////        }
//    }
    
}
