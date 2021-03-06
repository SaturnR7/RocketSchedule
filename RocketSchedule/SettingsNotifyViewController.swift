//
//  SettingsNotifyViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/10/02.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SettingNotifyViewController: UITableViewController {
    
    let notifyTime = UserDefaults()

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
    
    override func viewDidLoad() {
        
        print("SettingsNotifyViewController - viewDidLoad - Start")
        
        // 項目間の区切り線の色を変更する
//        self.tableView.separatorColor = .gray
        
        // ナビゲーションバーのタイトルを設定
        self.navigationItem.title = "通知設定"

        // Swtich設定
        notityTimeSlider.isContinuous = true
        
        // 通知時間の値をUserdefaultsから取得してテキストに表示、
        // スライダーに通知時間の値を設定
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // super 呼び出しでセルを取得
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        switch indexPath {
        case [0,0]:
            cell.layer.cornerRadius = 15
        default:
            break
        }
        
        return cell
    }
}
