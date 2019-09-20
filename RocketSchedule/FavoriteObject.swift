//
//  FacoriteObject.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/06/28.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import RealmSwift

// Realm Object
class FavoriteObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var rocketName = ""
    @objc dynamic var windowStart = ""
    @objc dynamic var windowEnd = ""
//    @objc dynamic var videoURL = ""
    @objc dynamic var addedDate = ""
    @objc dynamic var launchDate = Date()
    @objc dynamic var agency = ""
    @objc dynamic var rocketImageURL = ""
    @objc dynamic var rocketImageUrlForCell = ""
    @objc dynamic var missionName = ""
    @objc dynamic var agencyInfoUrl = ""

    let videoUrls = List<VideoUrlList>()
}

class VideoUrlList: Object{
    @objc dynamic var urlList = ""
}
