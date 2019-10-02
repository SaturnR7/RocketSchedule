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
    
    var notifySetting: Bool = false
    
    @IBOutlet weak var noSettingMessage: UILabel!
    
    @IBOutlet weak var notityTimeSlider: UISlider!
    
    @IBOutlet weak var settingTime: UILabel!
    
    @IBOutlet weak var labelVersion: UILabel!
    
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
        
        // アプリ起動時・フォアグラウンド復帰時の通知を設定する
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(SettingsViewController.onDidBecomeActive(_:)),
          name: UIApplication.didBecomeActiveNotification,
          object: nil
        )
        
        //  iOSの通知設定を確認する
        checkNotificationSetting()
        
        // 項目間の区切り線の色を変更する
        self.tableView.separatorColor = .gray

//        //ディクショナリ形式で初期値を指定できる
//        notifyTime.register(defaults: ["ChangeTime" : 10])
        
        labelVersion.text? =
            Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        // バックボタンのタイトルを設定
        // 遷移先のバックボタンにタイトルを設定する場合は、title: に文字を設定する。
        self.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // 戻るボタンの色を変更する
        self.navigationController?.navigationBar.tintColor = .white

        notityTimeSlider.isContinuous = true
        
        // 通知時間の値をUserdefaultsから取得してテキストに表示、
        // スライダーに通知時間の値を設定
        let value = notifyTime.integer(forKey: "ChangeTime")
        settingTime.text = String(format:"%5d", value)
        notityTimeSlider.value = Float(value)
        
        print("notityTimeSlider.value: \(notityTimeSlider.value)")
        print("SettingsViewController - viewDidLoad - End")
    }
    
    // アプリ起動時・フォアグラウンド復帰時に行う処理
    @objc func onDidBecomeActive(_ notification: Notification?) {
        
        // do something
        print("フォアグラウンド復帰")
        
        checkNotificationSetting()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        checkNotificationSetting()

    }
    
    override func viewDidAppear(_ animated: Bool) {

//        checkNotificationSetting()

    }
    
    func checkNotificationSetting() {
        
        // iOSの通知設定情報を取得
        // 通知設定がオンの場合：通知スイッチを有効にする
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            switch settings.authorizationStatus {
            case .authorized:
                print("Notification Status: authorized")
                self.notifySetting = true
                print("notifySwitchForSetting: \(self.notifySetting)")
                break
            case .denied:
                print("Notification Status: denied")
                self.notifySetting = false
                print("notifySwitchForSetting: \(self.notifySetting)")
                break
            case .notDetermined:
                print("Notification Status: notDetermined")
                self.notifySetting = false
                print("notifySwitchForSetting: \(self.notifySetting)")
                break
            case .provisional:
                print("Notification Status: provisional")
                break
            }
            
            DispatchQueue.main.async {

                if !self.notifySetting {
                    self.noSettingMessage.isHidden = false
                }else{
                    self.noSettingMessage.isHidden = true
                }
                
            }
        }
        
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
            
        case [0,0]: // 通知設定をタップした場合の処理
            print("通知設定タップ")
            
            print("didSelectRowAt - 通知設定タップ - notifySetting: \(notifySetting)")
            
            // false: 通知設定がオフの場合、メッセージ画面を表示してiOSの通知設定画面を開く
            if !notifySetting {
                
                // ① UIAlertControllerクラスのインスタンスを生成
                // タイトル, メッセージ, Alertのスタイルを指定する
                // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
                let alert: UIAlertController = UIAlertController(title: "通知機能を有効にする場合は「設定」で許可してください", message: "", preferredStyle:  UIAlertController.Style.alert)

                // ② Actionの設定
                // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                // OKボタン
                let defaultAction: UIAlertAction = UIAlertAction(title: "設定", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("「設定」タップ")
                    
                    // iOSの通知設定画面へ遷移
                    if let url = URL(string:"App-Prefs:root=NOTIFICATIONS_ID&path=com.gmail.hidemasa.kobayashi.RocketSchedule") {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
                // キャンセルボタン
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("「キャンセル」タップ")
                })

                // ③ UIAlertControllerにActionを追加
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)

                // ④ Alertを表示
                present(alert, animated: true, completion: nil)
                
            } else {
                
                // 通知設定画面へプッシュ遷移
                let storyboard = self.storyboard!
                let settingNotifyView = storyboard.instantiateViewController(withIdentifier: "settingNotifyView")
//                navigationController?.title = "通知設定"
                navigationController?.pushViewController(settingNotifyView, animated: true)
            }
            
        default:
            return
        }
        
    }

}
