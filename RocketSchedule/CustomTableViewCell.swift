//
//  CustomTableViewCell.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/23.
//  Copyright © 2019 zilch. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // 打ち上げ日付
    @IBOutlet weak var labelLaunchDate: UILabel!
    
    // 打ち上げ時刻
    @IBOutlet weak var labelLaunchTime: UILabel!
    
    // ロケット名
    @IBOutlet weak var labelRocketName: UILabel!
    
    // ミッション名
    @IBOutlet weak var labelMissionName: UILabel!
    
    // テスト用：ロケット画像表示
    @IBOutlet weak var rocketImageViewCell: UIImageView!
    
    // 通知ありなし確認
//    @IBOutlet weak var imageNotify: UIImageView!
    
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
        
        if imageUrl == "https://s3.amazonaws.com/launchlibrary/RocketImages/placeholder_480.png"{
            
            // ローカル画像を使用する。
            // ロケット画像なしの場合は共通の画像を使用するため、
            // 毎回ダウンロードせずローカルに保存している画像を使用する。
            let rocketNoImage = UIImage(named: "RocketNoImage_480")
            
            self.rocketImageViewCell.image =
                rocketNoImage?.cropping(to: CGRect(
                    x:      Int(30),
                    y:      Int(30),
                    width:  Int(self.rocketImageViewCell.frame.maxX),
                    height: Int(self.rocketImageViewCell.frame.maxY)))

            // 透過する
            self.rocketImageViewCell.alpha = 0.2

        }else{
            
            let url = URL(string: imageUrl)!
            
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    print("loadImage data: \(data)")
    //                print(response!)
                    
                    let original = UIImage(data: data!)
                    
                    self.rocketImageViewCell.image =
                        original?.cropping(to: CGRect(
                            x:      Int(original!.size.width/3),
                            y:      Int(original!.size.height/3),
                            width:  Int(self.rocketImageViewCell.frame.maxX),
                            height: Int(self.rocketImageViewCell.frame.maxY)))
                    
                    // 透過する
                    self.rocketImageViewCell.alpha = 0.2
                    
                }
                
            }.resume()

        }
    }
}

extension UIImage {
    
    func cropping(to: CGRect) -> UIImage? {
        
        var opaque = false
        
        if let cgImage = cgImage {
            switch cgImage.alphaInfo {
            case .noneSkipLast, .noneSkipFirst:
                opaque = true
            default:
                break
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(to.size, opaque, scale)
        
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
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
