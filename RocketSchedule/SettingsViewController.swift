//
//  SettingsViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/09/05.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import RealmSwift

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var notityTimeSlider: UISlider!
    
    @IBOutlet weak var settingTime: UILabel!
    
    @IBAction func notifyTimerSliderSender(_ sender: UISlider) {
        
        print("SettingsViewController - notifyTimerSliderSender - Start")
        
        //
        sender.setValue(sender.value.rounded(.down), animated: true)

        print("sender.value: \(sender.value)")
        
        let value = Int(sender.value)
        
        settingTime.text = String(format:"%5d", value)
        print("notityTimeSlider.value: \(notityTimeSlider.value)")

        //
        notifyTime.set(value, forKey: "ChangeTime")
        
        notifyDateChange(changeTime: value)
        
        print("SettingsViewController - notifyTimerSliderSender - End")
    }
    
    let notifyTime = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SettingsViewController - viewDidLoad - Start")

//        //ディクショナリ形式で初期値を指定できる
//        notifyTime.register(defaults: ["ChangeTime" : 10])
        
        notityTimeSlider.isContinuous = true
        
        let value = notifyTime.integer(forKey: "ChangeTime")

        settingTime.text = String(format:"%5d", value)
        
        notityTimeSlider.value = Float(value)
        print("notityTimeSlider.value: \(notityTimeSlider.value)")

        print("SettingsViewController - viewDidLoad - End")
    }

    func notifyDateChange(changeTime: Int){
        
        print("SettingsViewController - notifyDateChange - Start")

        // Notify Data remove from Realm
        let realm = try! Realm()
        let getRealmData = realm.objects(RealmNotifyObject.self)
        
        if getRealmData.count == 0 {
            print("getRealmData is 0 count")
            return
        }

        // 登録通知分の通知時刻を変更する
        for data in getRealmData{
            
            // ローカル通知のの内容
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
            content.title = data.notifyTitle
            content.body = data.notifyRocketName
   
            print("notifyDateChange - changeTime: \(-changeTime)")

            //Calendarクラスを使って日付（UTCの打ち上げ時刻）を減算して結果を返却する
            let newDate = Calendar.current.date(byAdding: .minute, value: -changeTime, to: data.notifyUtcDate)!

            print("notifyDateChange - data.notifyUtcDate: \(data.notifyUtcDate)")
            
            //componentの日付（UTCの打ち上げ時刻）はタイムゾーンに従って現地の日付時刻に変換される
            let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: newDate)
            
            print("notifyDateChange - component: \(component)")
            
            // ローカル通知リクエストを作成（現地時間に変換したcomponent日付を渡す）
            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)

            // ローカル通知リクエスト作成
            let request = UNNotificationRequest(identifier: data.notifyId,
                                                content: content,
                                                trigger: trigger)
            
            // ローカル通知リクエストを登録
            UNUserNotificationCenter.current().add(request){ (error : Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }

        print("SettingsViewController - notifyDateChange - End")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        tableView.separatorInset = .zero
        
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SettingViewController - tableView - didSelectRowAt indePath: \(indexPath)")
        
        switch indexPath {
            
        // Launch Libraryの輪作先を開く
        // 「データ提供元」タップ時の動作（Launch Libraryのリンク先を開く）
//        case [1,0]:
        case [1,1]: //「おひねり」項目を追加した場合は当コメントに置き換える
            print("indexPath : \(indexPath)")
            UIApplication.shared.open(URL(string: "https://launchlibrary.net/")! as URL,options: [:],completionHandler: nil)
            
        default:
            return
        }
        
    }

}
