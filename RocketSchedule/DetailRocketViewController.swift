//
//  DetailViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/30.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit

class DetailRocketViewController : UIViewController {
    
    var id:Int!
    var name:String!
    var videoURL:String!
    var notifySwitch:Bool!
    
    let notificationCenter = NotificationCenter.default

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
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("DetailRocketViewController - viewDidLoad Start")
        
        //打ち上げ画面から渡ってきた通知スイッチのboolを判定して
        //スイッチの状態を設定する。
        if (notifySwitch){
            
            notifyOutletSwitch.isOn = true
            
        }else{
            
            notifyOutletSwitch.isOn = false
            
        }
        
        print("DetailRocketViewController - viewDidLoad End")
        
    }
    
    @IBAction func videoLink(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: self.videoURL)! as URL,
                                  options: [:],
                                  completionHandler: nil)
        
        
    }
    
    
}

//Notification.name の拡張
extension Notification.Name {
    static let myNotificationRocketAdd = Notification.Name("myNotificationRocketAdd")
}

//Notification.name の拡張
extension Notification.Name {
    static let myNotificationRocketRemove = Notification.Name("myNotificationRocketRemove")
}
