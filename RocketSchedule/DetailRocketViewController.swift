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
    var notifySwitch:Bool!
    var rocketImageURL: String?
    
    let notificationCenter = NotificationCenter.default
    
    @IBOutlet weak var labelRocketName: UILabel!
    
    @IBOutlet weak var labelLaunchDate: UILabel!
    
    @IBOutlet weak var labelLaunchTime: UILabel!
    
    @IBOutlet weak var notifyOutletSwitch: UISwitch!
    
    @IBAction func notifyActionSwitch(_ sender: UISwitch) {
        
        if(sender.isOn){
            
            //ロケット情報の通知登録
            // Notification通知を送る（通知を送りたい箇所に書く。例えば何らかのボタンを押した際の処理の中等）
            notificationCenter.post(name: .myNotificationRocketAdd, object: nil)
            
        }else{
            
            //ロケット情報の通知削除
            // Notification通知を送る（通知を送りたい箇所に書く。例えば何らかのボタンを押した際の処理の中等）
            notificationCenter.post(name: .myNotificationRocketRemove, object: nil)
            
        }
    }
    
    @IBOutlet weak var labelAgency: UILabel!
    
    @IBOutlet weak var imageRocket: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("DetailRocketViewController - viewDidLoad Start")
        
        // ナビゲーションバーのアイテムの色　（戻る　＜）
        self.navigationController?.navigationBar.tintColor = .white
        
        // ナビゲーションバーのタイトル
        self.navigationItem.title = "詳細"

        
        // Rocket Name
        labelRocketName.text? = name ?? ""
        
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
        
        //打ち上げ画面から渡ってきた通知スイッチのboolを判定して
        //スイッチの状態を設定する。
        if (notifySwitch){
            notifyOutletSwitch.isOn = true
        }else{
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
            planVideoLinkOutlet.setTitle("ビデオなし", for: .normal)
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
    
    // Title set to VideoButton
    func videoButtonSetTitle(videoCount: Int){
        
        for target in 1...videoCount {
            switch target{
            case 1: planVideoLinkOutlet.setTitle("📹", for: .normal)
                
            case 2: planVideoLinkOutlet.setTitle("📹", for: .normal)
                    planVideoLinkOutlet2.setTitle("📹", for: .normal)
                
            case 3: planVideoLinkOutlet.setTitle("📹", for: .normal)
                    planVideoLinkOutlet2.setTitle("📹", for: .normal)
                    planVideoLinkOutlet3.setTitle("📹", for: .normal)
                
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
        
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.imageRocket.image = UIImage(data: data!)
                print(response!)
            }
            
            }.resume()
        
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

