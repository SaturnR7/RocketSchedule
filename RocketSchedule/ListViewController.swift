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
    
    // UIViewが表示できるかテスト
    var indicatorView: UIView!
    

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
        

        cell.labelRocketName?.numberOfLines = 0
        cell.labelRocketName?.text = "\(self.viewRocketPlanData[indexPath.row].rocketName)"
        
        print("ListViewController - tableView cellForRowAt end")

        return cell
    }
    
    // Indicator
    var indicator = UIActivityIndicatorView()
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        // インジケーターアイコンの丸み表現
        indicator.layer.cornerRadius = 8
        indicator.style = UIActivityIndicatorView.Style.white
//        indicator.center = self.indicatorView.center
        indicator.center = CGPoint.init(x: self.indicatorView.bounds.width / 2, y: self.indicatorView.bounds.height / 3)
        self.view.addSubview(indicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ListViewController - viewDidLoad start")
        
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
        indicator.backgroundColor = UIColor.black
        
        // cell borderline size
        tableView.separatorInset =
            UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);

        // NotificationCenterに登録する
        // Notificationのcatch関数は別に宣言
        notificationCenter.addObserver(self, selector: #selector(catchNotificationRocketAdd(notification:)), name: .myNotificationRocketAdd, object: nil)

        notificationCenter.addObserver(self, selector: #selector(catchNotificationRocketRemove(notification:)), name: .myNotificationRocketRemove, object: nil)
        

        print("ListViewController - viewDidLoad start")
        
        // Json Download
        launchJsonDownload()
        
        //テーブルビューの pull-to-refresh
        // -> launchJsonDownload()のcompletionhandlerに移動
//        refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        print("ListViewController - viewDidLoad end")
    }
    
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
        
//        print("ListViewController - ==jsonLaunches==\(notificationDate)")
//
//        print("ListViewController - forNotificationId - \(forNotificationId)")
//
//        if forNotificationId != nil{
//            notificationRocket()
//        }
        
        print("Jason Data: \(jsonLaunches)")
        print("ListViewController - viewDidAppear end")

    }

    // Rocket LibraryからJsonデータをダウンロード
    func launchJsonDownload(){
        
        print("ListViewController - launchJsonDownload start")

        //             string: "https://launchlibrary.net/1.4/launch?next=999999"){

        if let url = URL(
            string: "https://launchlibrary.net/1.4/launch?mode=verbose&next=100"){
            
            print("launchJsonDownload start inside URL")
            print("launchJsonDownload - URL: https://launchlibrary.net/1.4/launch?next=999999")

            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {

                    print("launchJsonDownload start inside URLSession")
                    
                    print(response)
                    
//                    let testdata = String(data: data, encoding: .utf8)!
//                    print("data:\(testdata)")
//                    print("data: \(data)")

                    // JSON decode to Struct-Launch
                    let json = try! JSONDecoder().decode(Launch.self, from: data)
                    
                    self.count = json.count
                    
                    self.jsonLaunches = json
                    
                    print("JSON Data: \(json)")
                    
                    for launch in json.launches {
//                        print("name:\(launch.name)")
                        
                        // calendarを日付文字列だ使ってるcalendarに設定
                        let formatterString = DateFormatter()
                        //TimeZoneはUTCにしなければならない。
                        //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
                        //日付を返してしまうため。
                        formatterString.timeZone = TimeZone(identifier: "UTC")
//                        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatterString.dateFormat = "MMMM dd, yyyy HH:mm:ss z"
                        let jsonDate = launch.windowstart
                        print ("jsonDate:\(jsonDate)")
                        
                        if let dateString = formatterString.date(from: jsonDate){
//                            print("dateString:\(String(describing: dateString))")
                            
                            formatterString.locale = Locale(identifier: "ja_JP")
                            formatterString.dateStyle = .full
                            formatterString.timeStyle = .medium

                            //ローカル通知登録用の日付をData型でセットする
                            self.utcDate = Date(timeInterval: 0, since: dateString)

                            //UTC + 9(Japan) 表示用の日付（日本時間）をセットする
                            self.addedDate = Date(timeInterval: 60*60*9*1, since: dateString)
//                            print("addedDate:\(String(describing: self.addedDate))")
//                            print("formatterString:\(formatterString.string(from: self.addedDate)))")
                            
                            //ID,LaunchDate added to struct
                            self.notificationDate.append(StructNotificationDate(id: launch.id,
                                                                launchData: self.utcDate,
                                                                rocketName: launch.name))
//                            print("notificationDate - struct: \(self.notificationDate)")
                            
                            //LaunchDate,RocketName added to struct for display on PlansView
                            self.viewRocketPlanData.append(StructViewPlans(
                                                        launchData: self.addedDate,
                                                        rocketName: launch.name))
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
                        
                        //テーブルビューの pull-to-refresh
                        self.refreshControl = UIRefreshControl()
                        self.refreshControl?.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
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
        let newDate = Calendar.current.date(byAdding: .minute, value: -15, to: launchDate)!
        print("Notification - newDate: \(newDate)")
        //componentの日付（UTCの打ち上げ時刻）はタイムゾーンに従って現地の日付時刻に変換される
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .timeZone], from: newDate)
        print("Notification - component: \(component)")

        // ローカル通知リクエストを作成（現地時間に変換したcomponent日付を渡す）
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        // ユニークなIDを作る
        let identifier = NSUUID().uuidString
        
        print("Notification - identifier : \(identifier)")
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
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
    
    //segueで詳細画面へ情報を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        print("ListViewController - prepare - Start")
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let launch = self.jsonLaunches.launches[indexPath.row]
            let controller = segue.destination as! DetailRocketViewController
            controller.title = "Detail"
            controller.id = launch.id
            controller.name = launch.name
            // 詳細画面にDate型の日付を渡す
            // 詳細画面での日付・時刻分け表示に都合がよいため
            controller.launchDate = viewRocketPlanData[indexPath.row].launchDate
//            controller.videoURL = launch.vidURLs?[0]
            controller.videoURL = launch.vidURLs
            
            
            // Agency name send to DetailView
            if launch.location.pads[0].agencies!.count != 0{
                if let agency = launch.location.pads[0].agencies{
                    print("ListViewController - prepare - agency : \(agency[0].abbrev)")
                    controller.agency = agency[0].abbrev
                }
            }else{
                controller.agency = "機関名なし"
            }
//            controller.agency = launch.agencies.abbrev
            
            
            controller.rocketImageURL = launch.rocket.imageURL

             
            forNotificationId = launch.id
            print("ListViewController - prepare : \(forNotificationId)")
            
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

