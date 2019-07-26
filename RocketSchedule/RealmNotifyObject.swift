//
//  RealmNotifyObject.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/07/22.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import RealmSwift

class RealmNotifyObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var notifyId = ""
}
