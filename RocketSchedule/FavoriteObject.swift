//
//  FacoriteObject.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/06/28.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var detail = ""
}
