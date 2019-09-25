//
//  DetailViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/30.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DetailRocketViewController : UIViewController {
    
    var id:Int?
    var name:String?
//    var videoURL:String!
    var launchDate: Date!
    var videoURL:[String]?
    var agency: String = ""
    var agencyFormalName: String = ""
    var agencyURL: String = ""
    var notifySwitch:Bool!
//    var countryCode: String = ""
    var rocketImageURL: String?
    
    let notificationCenter = NotificationCenter.default
    
    // ロケット名日本語変換クラス
    var rocketEng2Jpn = RocketNameEng2Jpn()
    
    @IBOutlet weak var labelRocketName: UILabel!
    
    @IBOutlet weak var labelRocketNameEng: UILabel!
    
    @IBOutlet weak var labelLaunchDate: UILabel!
    
    @IBOutlet weak var labelLaunchTime: UILabel!
    
    @IBOutlet weak var labelTimezone: UILabel!
    
    @IBOutlet weak var notifyOutletSwitch: UISwitch!
    
    @IBAction func buttonAgencyLink(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: self.agencyURL )! as URL,options: [:],completionHandler: nil)
    }
    
    
    @IBAction func notifyActionSwitch(_ sender: UISwitch) {
        
        if(sender.isOn){
            
            //ロケット情報の通知登録
            // Notification通知を送る（通知を送りたい箇所に書く。例えば何らかのボタンを押した際の処理の中等）
            notificationCenter.post(name: .myNotificationRocketAdd, object: nil)
            
            imageNotify.image = UIImage.init(named: "Icon_View_01_notify")
            
        }else{
            
            //ロケット情報の通知削除
            // Notification通知を送る（通知を送りたい箇所に書く。例えば何らかのボタンを押した際の処理の中等）
            notificationCenter.post(name: .myNotificationRocketRemove, object: nil)
            
            imageNotify.image = UIImage.init(named: "Icon_View_01_notify_off")
            
        }
    }
    
    @IBOutlet weak var imageNotify: UIImageView!
    
    @IBOutlet weak var labelAgency: UILabel!
    
    @IBAction func tapLabelAgency(_ sender: Any) {
        
        if self.agencyURL != ""{
            UIApplication.shared.open(URL(string: self.agencyURL )! as URL,options: [:],completionHandler: nil)
        }
    }
    
    
    @IBOutlet weak var imageRocket: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("DetailRocketViewController - viewDidLoad Start")
        
        // ナビゲーションバーのアイテムの色　（戻る　＜）
        self.navigationController?.navigationBar.tintColor = .white
        
        // ナビゲーションバーのタイトル
        self.navigationItem.title = "詳細"
        
        // バックボタンのタイトルを設定
        // 遷移先のバックボタンにタイトルを設定する場合は、title: に文字を設定する。
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // 通知スイッチの配色をへ設定（オン時の背景色）
        notifyOutletSwitch.onTintColor = UIColor.init(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
        
        // COPYメニューが表示されないので不採用
        // UIlabelのロングタップコピー実装
//        labelRocketName.isUserInteractionEnabled = true
//        let rocketNameLabelTg = UITapGestureRecognizer(target: self, action: #selector(tappedLabel(_:)))
//        labelRocketName.addGestureRecognizer(rocketNameLabelTg)

        // Rocket Name JPN
//        labelRocketName.text? = name ?? ""
        labelRocketName.text? = rocketEng2Jpn.checkStringSpecifyRocketName(name: self.name ?? "")

        // Rocket Name ENG
//        labelRocketNameEng.sizeToFit()
//        labelRocketNameEng.adjustsFontSizeToFitWidth = true
        labelRocketNameEng.text? = self.name ?? ""

        // Launch Date
        let formatterLaunchDate = DateFormatter()
        formatterLaunchDate.timeZone = TimeZone(identifier: "UTC")
        formatterLaunchDate.locale = Locale(identifier: "ja_JP")
        formatterLaunchDate.dateStyle = .full
        formatterLaunchDate.timeStyle = .none
        labelLaunchDate.text? = "\(formatterLaunchDate.string(from: launchDate))"
        
        // Launch Time
        let formatterLaunchTime = DateFormatter()
        formatterLaunchTime.timeZone = TimeZone(identifier: "UTC")
        formatterLaunchTime.locale = Locale(identifier: "ja_JP")
        formatterLaunchTime.dateStyle = .none
        formatterLaunchTime.timeStyle = .medium
        labelLaunchTime.text? = "\(formatterLaunchTime.string(from: launchDate))"
        
        // ユーザーのタイムゾーンの略語を設定する
        let getTimezoneAbb = DicTimeZone()
        labelTimezone.text? =
        "(\( getTimezoneAbb.getTimezoneAbbreviation(key: TimeZone.current.identifier)))"
//        labelTimezone.text? = "(\(TimeZone.current.identifier))"

        //打ち上げ画面から渡ってきた通知スイッチのboolを判定して
        //スイッチの状態を設定する。
        if (notifySwitch){
            imageNotify.image = UIImage.init(named: "Icon_View_01_notify")
            notifyOutletSwitch.isOn = true
        }else{
            imageNotify.image = UIImage.init(named: "Icon_View_01_notify_off")
            notifyOutletSwitch.isOn = false
        }
        
        // ロケットの動画をアイコンにセットする処理
        // vidURLs配列は動画URLが登録されている
        // 動画URLが0件の場合は、動画アイコンを表示しない
        if self.videoURL?.count != 0{
            
            let urlsCount = self.videoURL!.count
            
            // Title set to VideoButton
            videoButtonSetTitle(videoCount: urlsCount)
            
            // VideoButton controll by URL's count
            videoButtonControll(videoCount: urlsCount)
            
        }else{
            planVideoLinkOutlet.setTitle("ライブ配信がある場合はここにビデオアイコンが表示されます", for: .normal)
            planVideoLinkOutlet.isEnabled = false
            planVideoLinkOutlet2.isHidden = true
            planVideoLinkOutlet3.isHidden = true
        }
        
        // Agency Name
        // 機関名をラベル表示用にするため、Dictionaryから日本語表記名を取得する
        let dicAgencies = DicAgencies()
        let agency = dicAgencies.getAgencyOfJapanese(key: self.agency)
        print("DetailRocketViewController - viewDidLoad - agency: \(agency)")
        labelAgency.text = agency

        // Rocket Image Load
        if let rocketImageURL = rocketImageURL{
            loadImage(urlString: rocketImageURL)
        }
        //        let asyncImageView = AsyncImageView()
        //        imageRocket.image = asyncImageView.loadImage(urlString: rocketImageURL ?? "")

        print("DetailRocketViewController - viewDidLoad End")
        
        
    }
    
    // COPYメニューが表示されないので不採用
    // UILabelのロングタップ時の処理
//    @objc func tappedLabel(_ sender:UITapGestureRecognizer) {
//        UIPasteboard.general.string = labelRocketName.text
//        print("clip board :\(UIPasteboard.general.string!)")
//    }
    
    // Title set to VideoButton
    func videoButtonSetTitle(videoCount: Int){
        
        for target in 1...videoCount {
            switch target{
            case 1:
//                    planVideoLinkOutlet.setTitle("📹", for: .normal)
                    planVideoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                
            case 2:
//                    planVideoLinkOutlet.setTitle("📹", for: .normal)
//                    planVideoLinkOutlet2.setTitle("📹", for: .normal)
                    planVideoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    planVideoLinkOutlet2.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            case 3:
//                    planVideoLinkOutlet.setTitle("📹", for: .normal)
//                    planVideoLinkOutlet2.setTitle("📹", for: .normal)
//                    planVideoLinkOutlet3.setTitle("📹", for: .normal)
                    planVideoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    planVideoLinkOutlet2.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    planVideoLinkOutlet3.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            default:
                print("default")
            }
        }
    }
    
    // Hidden set to VideoLink
    func videoButtonControll(videoCount: Int){
        
        // videoCount -> 再生できる動画の本数
        switch videoCount {
        case 1: planVideoLinkOutlet.isHidden = false
                planVideoLinkOutlet2.isHidden = true
                planVideoLinkOutlet3.isHidden = true
            
        case 2: planVideoLinkOutlet.isHidden = false
                planVideoLinkOutlet2.isHidden = false
                planVideoLinkOutlet3.isHidden = true
            
        case 3: planVideoLinkOutlet.isHidden = false
                planVideoLinkOutlet2.isHidden = false
                planVideoLinkOutlet3.isHidden = false
            
        default:
            print("switch default")
        }
    }
    
    
    @IBAction func videoLink(_ sender: Any) {
        
//        UIApplication.shared.open(URL(string: self.videoURL)! as URL,options: [:],completionHandler: nil)
        UIApplication.shared.open(URL(string: self.videoURL?[0] ?? "")! as URL,options: [:],completionHandler: nil)
        
    }
    
    func loadImage(urlString: String) {
        
        // ロケット画像なしの場合は共通のロケット画像を使用するので、
        // ダウンロードせずローカル画像を使用する。
        if urlString == "https://s3.amazonaws.com/launchlibrary/RocketImages/placeholder_1920.png"{
            
            self.imageRocket.image = UIImage(named: "RocketNoImage_1920")
            // UIImageViewのサイズに収まるようにサイズを調整
            self.imageRocket.contentMode = .scaleAspectFill

        }else{
            
            let url = URL(string: urlString)!
            
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageRocket.image = UIImage(data: data!)
                    // UIImageViewのサイズに収まるようにサイズを調整
                    self.imageRocket.contentMode = .scaleAspectFill
//                print(response!)
                }
                
            }.resume()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as! RocketImageViewController
        controller.rocketImage = self.imageRocket.image

    }
    
    @IBAction func planVideoLink(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[0] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var planVideoLinkOutlet: UIButton!
    
    @IBAction func planVideoLink2(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[1] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var planVideoLinkOutlet2: UIButton!
    
    
    @IBAction func planVideoLink3(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[2] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var planVideoLinkOutlet3: UIButton!
    
}

//Notification.name の拡張
extension Notification.Name {
    static let myNotificationRocketAdd = Notification.Name("myNotificationRocketAdd")
}

//Notification.name の拡張
extension Notification.Name {
    static let myNotificationRocketRemove = Notification.Name("myNotificationRocketRemove")
}

