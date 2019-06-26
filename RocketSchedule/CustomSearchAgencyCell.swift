//
//  CustomSearchAgencyCell.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/06/21.
//  Copyright © 2019 zilch. All rights reserved.
//

import UIKit

class CustomSearchAgencyCell: UITableViewCell {
    
    @IBOutlet weak var labelAgency: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelAgency.backgroundColor = .white
    }

}
