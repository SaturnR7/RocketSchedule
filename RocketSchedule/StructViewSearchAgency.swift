//
//  StructViewSearchAgencies.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/06/21.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

struct StructViewSearchAgency {
    
    var name: String
    var abbrev: String

    init(name: String, abbrev: String){
        self.name = name
        self.abbrev = abbrev
    }
}
