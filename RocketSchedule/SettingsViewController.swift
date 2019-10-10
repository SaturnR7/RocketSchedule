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
    
    @IBOutlet weak var labelVersion: UILabel!
    
    @IBAction func tapCellNotifySetting(_ sender: Any) {
        
            print("通知設定タップ")
            
            // 項目間の区切り線の色を変更する
//            self.tableView.separatorColor = .gray

            print("didSelectRowAt - 通知設定タップ - notifySetting: \(notifySetting)")
            
            // false: 通知設定がオフの場合、メッセージ画面を表示してiOSの通知設定画面を開く
            if !notifySetting {
                
                // ① UIAlertControllerクラスのインスタンスを生成
                // タイトル, メッセージ, Alertのスタイルを指定する
                // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
                let alert: UIAlertController = UIAlertController(title: "通知設定を有効にする場合は\n「設定」で許可してください", message: "", preferredStyle:  UIAlertController.Style.alert)

                // ② Actionの設定
                // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                // OKボタン
                let defaultAction: UIAlertAction = UIAlertAction(title: "設定", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("「設定」タップ")
                    
                    // iOSの設定画面へ遷移
                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
    }
    
    @IBAction func tapUrlLink(_ sender: Any) {
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "リンク先をブラウザで開きます", message: "", preferredStyle:  UIAlertController.Style.alert)

        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "開く", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("「設定」タップ")
            
            // iOSの設定画面へ遷移
            UIApplication.shared.open(URL(string: "https://launchlibrary.net/")! as URL,options: [:],completionHandler: nil)

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

        
    }
    
    
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
//        self.tableView.separatorColor = .gray
        
        self.tableView.layer.cornerRadius = 15
        
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    // セルを増やす場合は、対応したsection数を増やす
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
//        tableView.separatorInset = .zero
        
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // super 呼び出しでセルを取得
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        switch indexPath {
        case [0,0]:
            cell.layer.cornerRadius = 15
//            cell.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
            //         indicator.layer.cornerRadius = 10
            cell.accessoryView = UIImageView(image: UIImage(named: "Disclosure-Original_01.png"))
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        case [1,0]:
            cell.layer.cornerRadius = 15
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.accessoryView = UIImageView(image: UIImage(named: "Disclosure-Original_01.png"))
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            
//        case [1,1]:
        case [1,2]:
            cell.layer.cornerRadius = 15
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default:
            break
        }

//        if indexPath == [0,0] {
//            cell.accessoryView = UIImageView(image: UIImage(named: "Disclosure-forward-24.png"))
//        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SettingViewController - tableView - didSelectRowAt indePath: \(indexPath)")
        
        switch indexPath {
            
        // Launch Libraryの輪作先を開く
        // 「データ提供元」タップ時の動作（Launch Libraryのリンク先を開く）
//        case [1,0]:
            
//        case [1,1]:
//            print("indexPath : \(indexPath)")
//            UIApplication.shared.open(URL(string: "https://launchlibrary.net/")! as URL,options: [:],completionHandler: nil)
            
        // selection=none の場合、処理遅延（アラート表示が遅れる）ため、
        // tapRecognizerを利用してタップ時の動作を実装したので、以下はコメント化する
//        case [0,0]: // 通知設定をタップした場合の処理
//        処理はtapRecognizerへ移動
            
        default:
            return
        }
        
    }

}
