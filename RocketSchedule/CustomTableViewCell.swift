//
//  CustomTableViewCell.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/23.
//  Copyright © 2019 zilch. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var labelLaunchDate: UILabel!
    
    @IBOutlet weak var labelLaunchTime: UILabel!
    
    @IBOutlet weak var labelRocketName: UILabel!
    
    // テスト用：ロケット画像表示
    @IBOutlet weak var rocketImageViewCell: UIImageView!
    
    // 通知ありなし確認
    @IBOutlet weak var imageNotify: UIImageView!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
