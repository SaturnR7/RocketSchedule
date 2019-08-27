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

    func rocketImageSetCell(imageUrl: String) {
        let url = URL(string: imageUrl)!
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                print("loadImage data: \(data)")

                print(response!)
                self.rocketImageViewCell.image = UIImage(data: data!)

                self.rocketImageViewCell.image =
                    UIImage.resizeUIImage(
                        image: self.rocketImageViewCell.image!,
                        width: self.rocketImageViewCell.frame.maxX,
                        height: self.rocketImageViewCell.frame.maxY
                    )
                
                // 透過する
                self.rocketImageViewCell.alpha = 0.25
                
            }
            
        }.resume()
    }
    
}

extension UIImage{
    
    // Resizeのクラスメソッドを作る.
    class func resizeUIImage(image : UIImage,width : CGFloat, height : CGFloat)-> UIImage!{
        
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        // コンテキストに画像を描画する.
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
