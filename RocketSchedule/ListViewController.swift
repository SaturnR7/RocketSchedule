//
//  ListViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/13.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import RealmSwift
//import UserNotifications

class ListViewController: UITableViewController {
    
//    var items = [Launch]()
//    var item:Launch?
    var count: Int = 0
    var jsonLaunches: Launch!
    var addedDate:Date!
    var utcDate:Date!
    
    //For Rocket Launch Notification
    var notificationDate = [StructNotificationDate]()
    
    //For Display on PlansView
    var viewRocketPlanData = [StructViewPlans]()
    
    // Grobal Rocket ID
    var forNotificationId: Int!
    
    //notification 受け取る側でのクラス宣言
    let notificationCenter = NotificationCenter.default
    
    // ローカル通知のの内容
    let content = UNMutableNotificationContent()
    
    // インジケーター用のUIViewを宣言
    var indicatorView: UIView!
    
    // ロケット名日本語変換クラス
    var rocketEng2Jpn = RocketNameEng2Jpn()
    
    // TimeRelated.swiftを使った処理だが不要のためコメント化
    // Timeintervalの値
//    var timeintervalValue: Double = 0
    
    // セルに表示するロケット画像
    var imageForRocketCell: UIImage!
    
//    // 詳細画面の通知スイッチを有効・無効にするための情報
//    // iOSの通知設定がオンの場合：false
//    // オフの場合：true
//    var notifySwitchForSetting: Bool = true
    

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        print("tableView numberOfRowsInSection start")

        print("count:\(count)")
        
        print("tableView numberOfRowsInSection end")

        return count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("ListViewController - tableView cellForRowAt start")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        let formatterString = DateFormatter()
        
//        var testDate = viewRocketPlanData[indexPath.row].launchDate
//        testDate.
        
        //TimeZoneはUTCにしなければならない。
        //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
        //日付を返してしまうため。
        formatterString.timeZone = TimeZone(identifier: "UTC")
        formatterString.dateFormat = "yyyy/MM/dd (EEE)"
        formatterString.locale = Locale(identifier: "ja_JP")
        print("ListViewController - tableview - launchDate: \(viewRocketPlanData[indexPath.row].launchDate)")
        cell.labelLaunchDate?.numberOfLines = 0
        cell.labelLaunchDate?.text = "\(formatterString.string(from: viewRocketPlanData[indexPath.row].launchDate))"
        
        
        // Launch Time
        let formatterLaunchTime = DateFormatter()
        formatterLaunchTime.timeZone = TimeZone(identifier: "UTC")
        formatterLaunchTime.locale = Locale(identifier: "ja_JP")
        formatterLaunchTime.dateStyle = .none
        formatterLaunchTime.timeStyle = .medium
        cell.labelLaunchTime?.numberOfLines = 0
        cell.labelLaunchTime?.text = "\(formatterLaunchTime.string(from: viewRocketPlanData[indexPath.row].launchDate))"
        
        // ロケットを日本語名に変換して表示する
        //        cell.labelRocketName?.text = "\(self.viewRocketPlanData[indexPath.row].rocketName)"
        cell.labelRocketName?.numberOfLines = 0
        // フォントサイズの自動調節
        cell.labelRocketName?.adjustsFontSizeToFitWidth = true
        cell.labelRocketName?.text =
            rocketEng2Jpn.checkStringSpecifyRocketName(name: self.viewRocketPlanData[indexPath.row].rocketName)
        
        // ミッション名を表示する
        cell.labelMissionName?.numberOfLines = 0
        cell.labelMissionName?.text = rocketEng2Jpn.getMissionName(name: self.viewRocketPlanData[indexPath.row].rocketName)

        // テスト：ロケット画像の表示
//        cell.rocketImageViewCell.image = UIImage(named: "Atlas+V+551_480")
////        let imageViewScale = max(cell.rocketImageViewCell.image.size. ,
////                                 cell.rocketImageViewCell.image.size.height / viewHeight)
//        let originalImage = UIImage(named: "Atlas+V+551_480")
//        let cropZone = CGRect(x: 2, y: 5, width: 5, height: 5)
//        guard let cutImage = originalImage?.cgImage?.cropping(to: cropZone)
//            else{
//                    return cell
//            }
//        cell.rocketImageViewCell.image? = UIImage(cgImage: cutImage)
        
        // ロケット画像の表示
        // 画像URLの文字列を変更（解像度を1920より小さく）
        print("tableView - Before ImageURL: \(self.viewRocketPlanData[indexPath.row].rocketImageURL)")
//        // 画像の設定.
//        let myImage:UIImage = UIImage(named:"Atlas+V+551_480")!
        let replacedImageURL = self.viewRocketPlanData[indexPath.row].rocketImageURL.replacingOccurrences(of: "_1920.png", with: "_480.png")
        print("tableView - After ImageURL: \(replacedImageURL)")
//        loadImage(urlString: replacedImageURL)
        cell.rocketImageSetCell(imageUrl: replacedImageURL)


        // テスト：通知アイコン表示
//        let imageOriginalNotify = UIImage(named: "Icon_View_01_notify")
//        let reSize = CGSize(width: (imageOriginalNotify?.size.width)! / 2, height: (imageOriginalNotify?.size.height)! / 2)
//        cell.imageNotify.image = imageOriginalNotify?.reSizeImage(reSize: reSize)
//        cell.imageNotify.image = imageOriginalNotify?.scaleImage(scaleSize: 0.5)
        // テスト：通知アイコン表示
//        cell.imageNotify.image = UIImage(named: "Icon_View_01_notify")
//        // 通知情報が登録されていない場合は、通知アイコンを非表示にする
//        // Notify Data remove from Realm
//        let realm = try! Realm()
//        let filterRealm = realm.objects(RealmNotifyObject.self).filter("id = \(self.viewRocketPlanData[indexPath.row].id)")
//        // 通知データ取得件数が０件（登録していない）はスイッチをオフにする
//        if (filterRealm.count == 0){
//            cell.imageNotify.isHidden = true
//        }

        print("ListViewController - tableView cellForRowAt end")

        return cell
    }
    
    // Indicator
    var indicator = UIActivityIndicatorView()
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        // インジケーターアイコンの丸み表現
        indicator.layer.cornerRadius = 10
        
        indicator.style = UIActivityIndicatorView.Style.whiteLarge
        indicator.backgroundColor =
            UIColor.init(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)
//        indicator.center = self.indicatorView.center
        indicator.center = CGPoint.init(x: self.indicatorView.bounds.width / 2, y: self.indicatorView.bounds.height / 3)
        self.view.addSubview(indicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ListViewController - viewDidLoad start")
        
//        print("Timezone: \(TimeZone.ReferenceType.local)")
//        print("Timezone secondsFromGMT : \(Calendar.current.timeZone.secondsFromGMT())")
//        print("TimeZone Current Abbreviation: \(TimeZone.current.abbreviation())")
//        print("Timezone List: \(TimeZone.abbreviationDictionary)")
//        print("TimeZone Identifiers: \(TimeZone.knownTimeZoneIdentifiers)")
        
        // ディクショナリ形式で初期値を指定できる
        let notifyTime = UserDefaults()
        notifyTime.register(defaults: ["ChangeTime" : 10])
        
        // バックボタンのタイトルを設定
        // 遷移先のバックボタンにタイトルを設定する場合は、title: に文字を設定する。
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        // Realmの通知済み情報の存在を確認し、存在する場合はRealmのデータを削除する
//        checkAndRemoveRealmNotify()
        
        // インジケーター用のUIViewを表示
        // init Boundsで全画面にviewを表示
        indicatorView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
//        let bgColor = UIColor.gray
        let bgColor = UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        indicatorView.backgroundColor = bgColor
        indicatorView.isUserInteractionEnabled = true
        self.view.addSubview(indicatorView)
        
        // Indicator
        activityIndicator()
        indicator.startAnimating()
//        indicator.backgroundColor = UIColor.black
        
        // cell borderline size
        tableView.separatorInset =
            UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);

        // NotificationCenterに登録する
        // Notificationのcatch関数は別に宣言
        notificationCenter.addObserver(self, selector: #selector(catchNotificationRocketAdd(notification:)), name: .myNotificationRocketAdd, object: nil)

        notificationCenter.addObserver(self, selector: #selector(catchNotificationRocketRemove(notification:)), name: .myNotificationRocketRemove, object: nil)
        
        // TimeRelated.swiftを使った処理だが不要のためコメント化
//        // GMTからTimeinterval用の値を取得
//        let timeRelated = TimeRelated()
//        let gmtValue = timeRelated.getGmtValue()
//        print("Abbreviation Value: \(gmtValue)")
//        timeintervalValue = timeRelated.getTimeintervalValue(gmtValue: gmtValue)
        

        // Json Download
        launchJsonDownload()
        
        // Rocket Image Download
        rocketImageDownload()
        
        print("ListViewController - viewDidLoad end")
    }
    
    // 配信済みの通知情報の存在チェックし、存在する場合はRealmのデータを削除する
    // スレッド間での例外発生：当機能は保留にする
//    func checkAndRemoveRealmNotify(){
//
//        print("ListViewController - checkAndRemoveRealmNotify - Start")
//
//        // 未配信の通知情報一覧
//        let center = UNUserNotificationCenter.current()
//
//
//        // Notify Data remove from Realm
//        let realm = try! Realm()
//        let getRealmData = realm.objects(RealmNotifyObject.self)
//
//        if getRealmData.count == 0 {
//            print("getRealmData is 0 count")
//            return
//        }
//
//        // 登録通知分の通知時刻を変更する
//        for data in getRealmData{
//
//            print("data notifyId: \(data)")
//            // 通知センター未配信一覧を取得する
//            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
//
//                // 未配信分繰り返し、Realmの通知情報と一致した場合は、Realmデータを削除する
//                for request in requests{
//                    print("Pending Notify: \(request)")
//                    print("Pending Notify ID: \(request.identifier)")
//
//                    //
//                    if data.notifyId == request.identifier{
//
//                        print("Notify ID Match! ID: \(data.notifyId)")
//                        try! realm.write {
//                            realm.delete(data)
//                        }
//                        break
//                    }
//                }
//            }
//        }
//        print("ListViewController - checkAndRemoveRealmNotify - End")
//    }
    
    //リフレッシュ処理
    @objc func refresh(sender: UIRefreshControl) {
        print("ListViewController - In refresh Start")
        //Json再取得
        launchJsonDownload()
        
        sender.endRefreshing()
        
        print("ListViewController - In refresh End")
    }
    
    override func viewDidAppear(_ animated: Bool){
        
        super.viewDidAppear(animated)

        print("ListViewController - viewDidAppear start")

        let userDefaultsValue = UserDefaults.standard.integer(forKey: "ChangeTime")
        print("userdefaults ChangeTime: \(userDefaultsValue)")
        print("userdefaults ChangeTime(minus): \(-userDefaultsValue)")
        
        // 未配信の通知情報一覧
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            
            for request in requests{
                print("Pending Notify: \(request)")
                print("Pending Notify ID: \(request.identifier)")
            }
        }

//        // iOSの通知設定情報を取得
//        // 通知設定がオンの場合：通知スイッチを有効にする
//        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//
//            switch settings.authorizationStatus {
//            case .authorized:
//                print("Notification Status: authorized")
//                self.notifySwitchForSetting = true
//                print("notifySwitchForSetting: \(self.notifySwitchForSetting)")
//                break
//            case .denied:
//                print("Notification Status: denied")
//                self.notifySwitchForSetting = false
//                print("notifySwitchForSetting: \(self.notifySwitchForSetting)")
//                break
//            case .notDetermined:
//                print("Notification Status: notDetermined")
//                break
//            case .provisional:
//                print("Notification Status: provisional")
//                break
//            }
//        }

//        print("ListViewController - ==jsonLaunches==\(notificationDate)")
//
//        print("ListViewController - forNotificationId - \(forNotificationId)")
//
//        if forNotificationId != nil{
//            notificationRocket()
//        }
        
//        print("Json Data: \(jsonLaunches)")
        
        // テスト
//        let indexPathForTop = IndexPath(row: 0, section: 0)
//        let cell = tableView.cellForRow(at: indexPathForTop) as! CustomTableViewCell
//        cell.imageNotify.isHidden = true
//        // テーブル情報のリロード
//        self.tableView.reloadData()

//        // Realmの通知済み情報の存在を確認し、存在する場合はRealmのデータを削除する
//        checkAndRemoveRealmNotify()
        
        print("ListViewController - viewDidAppear end")

    }

    // Rocket LibraryからJsonデータをダウンロード
    func launchJsonDownload(){
        
        print("ListViewController - launchJsonDownload start")

        //             string: "https://launchlibrary.net/1.4/launch?next=999999"){

        if let url = URL(
            string: "https://launchlibrary.net/1.4/launch?mode=verbose&next=5"){
            
            print("launchJsonDownload start inside URL")
            print("launchJsonDownload - URL: https://launchlibrary.net/1.4/launch?next=999999")

            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {

                    print("launchJsonDownload start inside URLSession")
                    
                    print(response)
                    
//                    let testdata = String(data: data, encoding: .utf8)!
//                    print("data:\(testdata)")
//                    print("data: \(String(data: data, encoding: .utf8)!)")

                    // JSON decode to Struct-Launch
                    let json = try! JSONDecoder().decode(Launch.self, from: data)
                    
                    self.count = json.count
                    
                    self.jsonLaunches = json
                    
//                    print("JSON Data: \(json)")
                    
                    for launch in json.launches {
//                        print("name:\(launch.name)")
                        
                        // calendarを日付文字列だ使ってるcalendarに設定
                        let formatterString = DateFormatter()
                        
                        // TimeZoneはUTCにしなければならない。
                        // 理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
                        // 日付を返してしまうため。
                        formatterString.timeZone = TimeZone(identifier: "UTC")
//                        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatterString.dateFormat = "MMMM dd, yyyy HH:mm:ss z"
                        
                        // 固定フォーマットで表示
                        // 【info.plist】
                        // Localization native development region：Japan
                        // localeプロパティを設定しないと、日付変換処理でnilが返ってしまう。
                        formatterString.locale = Locale(identifier: "en_US_POSIX")
                        
                        let jsonDate = launch.windowstart
                        print("jsonDate:\(jsonDate)")
                        
                        if let dateString = formatterString.date(from: jsonDate){
//                            print("dateString:\(String(describing: dateString))")
                            
                            formatterString.locale = Locale(identifier: "ja_JP")
                            formatterString.dateStyle = .full
                            formatterString.timeStyle = .medium

                            //ローカル通知登録用の日付をData型でセットする
                            self.utcDate = Date(timeInterval: 0, since: dateString)

                            // システム設定しているタイムゾーンを元にUTCから発射日時を算出する
//                            self.addedDate = Date(timeInterval: 60*60*9*1, since: dateString)
                            // TimeRelated.swiftを使った処理だが不要のためコメント化
//                            print("timeintervalValue: \(self.timeintervalValue)")
//                            self.addedDate = Date(timeInterval: self.timeintervalValue, since: dateString)
                            self.addedDate = Date(timeInterval: Double(Calendar.current.timeZone.secondsFromGMT()), since: dateString)

                            //ID,LaunchDate added to struct
                            // launchDateにUTCの日付を渡す。
                            // （通知情報登録時にUTCの日付を現地のタイムゾーンに変更して登録する）
                            self.notificationDate.append(StructNotificationDate(id: launch.id,
                                                                launchData: self.utcDate,
                                                                rocketName: launch.name))
//                            print("notificationDate - struct: \(self.notificationDate)")
                            
                            //LaunchDate,RocketName added to struct for display on PlansView
                            self.viewRocketPlanData.append(StructViewPlans(
                                                                id: launch.id,
                                                                launchData: self.addedDate,
                                                                rocketName: launch.name,
                                                                rocketImageURL: launch.rocket.imageURL ?? ""))
//                            print("viewRocketPlanData - struct: \(self.viewRocketPlanData)")

                        }else{
                            print("dateString is nil")
                        }
                    }

                    
                    // 非同期処理完了後の処理（Jsonダウンロード完了後）
                    DispatchQueue.main.async {
                        
                        // テーブル情報のリロード
                        self.tableView.reloadData()
                        
                        // インジケーターアイコンを非表示
                        self.indicator.stopAnimating()
                        
                        // インジケーター用のUIViewを非表示
                        self.indicatorView.isHidden = true
                        
                        // テーブルビューの pull-to-refresh
                        // 有効にする場合はコメントを解除
//                        self.refreshControl = UIRefreshControl()
//                        self.refreshControl?.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
                    }
                    
//                    //直近のロケットの打ち上げ予定を通知する
//                    self.notificationRocket()
                    
                    print("launchJsonDownload end inside")

                } else {
                    print(error ?? "Error")
                }
            })
            
            task.resume()

            }

        print("ListViewController - launchJsonDownload end")
    }
    
    //ロケット情報のローカル通知を登録する
    func notificationRocketAdd(){
        
        print("ListViewController - notificationRocket Start")

        print("forNotificationId In notificationRocket() - \(forNotificationId)")

        let userDefaultsValue = UserDefaults.standard.integer(forKey: "ChangeTime")
        print("ListViewController - userdefaults ChangeTime: \(userDefaultsValue)")
        print("ListViewController - userdefaults ChangeTime(minus): \(-userDefaultsValue)")

        // ローカル通知のの内容
        content.sound = UNNotificationSound.default
        content.title = "まもなくロケット打ち上げ"
        
        var notifyRocketInfomation = self.notificationDate.filter({$0.id == forNotificationId})
        //        content.subtitle = "ロケット名"
        print("Notification - RocketName: \(notifyRocketInfomation[0].rocketName)")
        content.body = "\(notifyRocketInfomation[0].rocketName)"

        // ローカル通知実行日時をセット
        let launchDate = notifyRocketInfomation[0].launchDate
        print("Notification - date: \(launchDate)")

        //Calendarクラスを使って日付（UTCの打ち上げ時刻）を減算して結果を返却する
        let newDate = Calendar.current.date(byAdding: .minute, value: -userDefaultsValue, to: launchDate)!
        print("Notification - newDate: \(newDate)")
        //componentの日付（UTCの打ち上げ時刻）はタイムゾーンに従って現地の日付時刻に変換される
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: newDate)
        print("Notification - component: \(component)")

        // ローカル通知リクエストを作成（現地時間に変換したcomponent日付を渡す）
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        // ユニークなIDを作る
        let identifier = NSUUID().uuidString
        
        print("Notification - identifier : \(identifier)")
        
        print("Notification - Register Date: \(trigger.nextTriggerDate())")
        
        // ローカル通知リクエスト作成
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        // ローカル通知リクエストを登録
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        
        // Notify Data add to Realm
        let author = RealmNotifyObject()
        author.id = forNotificationId
        author.notifyId = identifier
        author.notifyUtcDate = launchDate
        author.notifyTitle = "まもなくロケット打ち上げ"
        author.notifyRocketName = notifyRocketInfomation[0].rocketName
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(author)
        }
        

        print("ListViewController - notificationRocket End")
    }
    
    //ロケット情報の通知情報を削除する
    func notificationRocketRemove() throws{

        print("ListViewController - In notificationRocketRemove Start")

        let center = UNUserNotificationCenter.current()
        var notifyIdForDelete: Int = 0
        // Realmクエリのためoptionalを外す
        if let forNotificationId = forNotificationId{
            notifyIdForDelete = forNotificationId
        }
        
        print("notifyId : \(notifyIdForDelete)")

        // Notify Data remove from Realm
        let realm = try! Realm()
        let filterRealm = realm.objects(RealmNotifyObject.self).filter("id = \(notifyIdForDelete)")

        print("notifyRocketInfomation : \(filterRealm[0].id)")
        print("notifyRocketInfomation : \(filterRealm[0].notifyId)")
        
        // Delete Notify
        center.removePendingNotificationRequests(
            withIdentifiers: [filterRealm[0].notifyId])

        try! realm.write {
            realm.delete(filterRealm)
        }

        print("ListViewController - In notificationRocketRemove End")
    }
    
    // セル表示用の画像ダウンロード
    func rocketImageDownload(){
        
    }
    
    func loadImage(urlString: String) {

        let url = URL(string: urlString)!

        URLSession.shared.dataTask(with: url) {(data, response, error) in

            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
//                print("loadImage data: \(data)")
                self.imageForRocketCell = UIImage(data: data!)
//                print(response!)
            }

        }.resume()

    }
//    func loadImage(urlString: String) -> UIImage {
//
//        let url = URL(string: urlString)!
//
//        var result: UIImage!
//
//        // セマフォを0で初期化
//        let semaphore = DispatchSemaphore(value: 0)
////        processAsync() { (url: String) in
////        }
//        URLSession.shared.dataTask(with: url) {(data, response, error) in
//
//
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            DispatchQueue.main.async {
//                print("loadImage data: \(data)")
//                self.imageForRocketCell = UIImage(data: data!)
//                print(response!)
//            }
//            // セマフォをインクリメント（+1）
//            semaphore.signal()
//
//        }.resume()
//        // セマフォをデクリメント（-1）、ただしセマフォが0の場合はsignal()の実行を待つ
//        semaphore.wait()
//        return result
//    }
    
    // 非同期処理
    func processAsync(completion: @escaping (_ url: String) -> Void) { }
    
    //segueで詳細画面へ打ち上げ情報を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        print("ListViewController - prepare - Start")
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let launch = self.jsonLaunches.launches[indexPath.row]
            print("ListViewController - prepare - launch: \(launch)")

            let controller = segue.destination as! DetailRocketViewController
            controller.id = launch.id
            controller.name = launch.name
            // 詳細画面にDate型の日付を渡す
            // 詳細画面での日付・時刻分け表示に都合がよいため
            controller.launchDate = viewRocketPlanData[indexPath.row].launchDate
            //            controller.videoURL = launch.vidURLs?[0]
            controller.videoURL = launch.vidURLs
            
            
            // Agency name send to DetailView
//            if launch.location.pads[0].agencies != nil{
//                if launch.location.pads[0].agencies!.count != 0{
//                    if let agency = launch.location.pads[0].agencies{
//                        print("ListViewController - prepare - agency : \(agency[0].abbrev)")
//                        controller.agency = agency[0].abbrev
//                    }
//                }else{
//                    controller.agency = "ー"
//                }
//            }else{
//                controller.agency = "ー"
//            }
////            controller.agency = launch.agencies.abbrev
            // Launchの全項目から機関を取得する
            let getAgency = GetElementLaunch()
            let result:[String] = getAgency.getAgencyNameInSingleLaunch(launchData: launch)
            controller.agency = result[0]
            controller.agencyFormalName = result[1]
            controller.agencyURL = result[2]
            print("ListViewController - prepare - controller.agency : \(controller.agency)")
            print("ListViewController - prepare - controller.agencyFormalName : \(controller.agencyFormalName)")
            print("ListViewController - prepare - controller.agencyURL : \(controller.agencyURL)")

            // 発射する国（コード）
//            if let agency = launch.location.pads[0].agencies{
//                controller.countryCode = agency[0].countryCode
//            }
            
            controller.rocketImageURL = launch.rocket.imageURL

             
            forNotificationId = launch.id
            print("ListViewController - prepare - forNotificationId : \(forNotificationId)")
            
            // ロケット情報を通知登録してるか確認する
            // 登録している場合は、詳細画面のUISwitchをオンにする情報を渡す
            var notifyIdForDelete: Int = 0
            if let forNotificationId = forNotificationId{
                notifyIdForDelete = forNotificationId
            }
            print("notifyId : \(notifyIdForDelete)")
            // Notify Data remove from Realm
            let realm = try! Realm()
            let filterRealm = realm.objects(RealmNotifyObject.self).filter("id = \(notifyIdForDelete)")
            // 通知データ取得件数が０件（登録していない）はスイッチをオフにする
            if (filterRealm.count != 0){
                controller.notifySwitch = true
            }else{
                controller.notifySwitch = false
            }

//            // iOS通知設定のオンオフ情報
//            controller.notifySwitchForSetting = self.notifySwitchForSetting
            
        }
        
        print("ListViewController - prepare - End")
    }
    
    //ロケット情報の通知登録（Notificationを受け取り後）
    @objc func catchNotificationRocketAdd(notification: Notification) -> Void {
        print("ListViewController - In catchNotificationRocketAdd Start")
        
        print("catchNotificationRocketAdd - forNotificationId : \(forNotificationId)")
        
        //直近のロケットの打ち上げ予定を通知する
        self.notificationRocketAdd()

        print("ListViewController - In catchNotificationRocketAdd End")
    }
    
    //ロケット情報の通知削除（Notificationを受け取り後）
    @objc func catchNotificationRocketRemove(notification: Notification) -> Void {
        print("ListViewController - In catchNotificationRocketRemove Start")
        
        print("catchNotificationRocketRemove - forNotificationId : \(forNotificationId)")
        
        //直近のロケットの打ち上げ予定を通知する
        do{
            try? self.notificationRocketRemove()
        }catch{
            
        }
        
        print("ListViewController - In catchNotificationRocketRemove End")
    }

}

extension UIImage {
    // resize image
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

extension UIImage{
    
    // Resizeのクラスメソッドを作る.
    class func ResizeUIImage(image : UIImage,width : CGFloat, height : CGFloat)-> UIImage!{
        
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
