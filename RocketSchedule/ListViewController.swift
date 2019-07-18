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
    
    var items = [Launch]()
    var item:Launch?
    var count: Int = 0
    var jsonLaunches: Launch!
    var addedDate:Date!
    var utcDate:Date!
    //For Rocket Launch Notification
    var notificationDate = [StructNotificationDate]()
    //For Display on PlansView
    var viewRocketPlanData = [StructViewPlans]()
    var forNotificationId: Int!
    
    //notification 受け取る側でのクラス宣言
    let notificationCenter = NotificationCenter.default
    
    // ローカル通知のの内容
    let content = UNMutableNotificationContent()
    
    //For Notification ID
    var notificationIdData = [StructNotificationId]()
    
    // UserDefaults
    let encoderForUserdDefaults = JSONEncoder()
    let defaultsForRocketNotification = UserDefaults.standard



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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ListViewController - viewDidLoad start")
        
        // cell borderline size
        tableView.separatorInset =
            UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);

        // NotificationCenterに登録する
        // Notificationのcatch関数は別に宣言
        notificationCenter.addObserver(self, selector: #selector(catchNotificationRocketAdd(notification:)), name: .myNotificationRocketAdd, object: nil)

        notificationCenter.addObserver(self, selector: #selector(catchNotificationRocketRemove(notification:)), name: .myNotificationRocketRemove, object: nil)
        

        print("ListViewController - viewDidLoad start")

        launchJsonDownload()
        
        
        //テーブルビューの pull-to-refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
//        self.tableView.reloadData()
        
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
    
    //RealmTest
//    private var realm: Realm!
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)

        print("ListViewController - viewDidAppear start")

        print("ListViewController - ==jsonLaunches==\(notificationDate)")
        
        print("ListViewController - forNotificationId - \(forNotificationId)")
//
//        if forNotificationId != nil{
//            notificationRocket()
//        }
        
        
        // Realm Test
//        let realm = try! Realm()
//        // 文字列で検索条件を指定します
//        var testRealm = realm.objects(FavoriteObject.self)
//        print("testRealm : \(testRealm)")
//        print("testRealm : \(testRealm.filter("detail CONTAINS 'Test'"))")


        print("ListViewController - viewDidAppear end")

    }


    func launchJsonDownload(){
        
        print("ListViewController - launchJsonDownload start")
        
        if let url = URL(
            string: "https://launchlibrary.net/1.4/launch?next=999999"){
            
            print("launchJsonDownload start inside URL")
            print("launchJsonDownload - URL: https://launchlibrary.net/1.4/launch?next=999999")

            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {

                    print("launchJsonDownload start inside URLSession")
                    
                    print(response)
                    
//                    let testdata = String(data: data, encoding: .utf8)!
//                    print("data:\(testdata)")

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
                        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let jsonDate = launch.windowstart
//                        print ("jsonDate:\(jsonDate)")
                        
                        if let dateString = formatterString.date(from: jsonDate){
                            print("dateString:\(String(describing: dateString))")
                            
                            formatterString.locale = Locale(identifier: "ja_JP")
                            formatterString.dateStyle = .full
                            formatterString.timeStyle = .medium

                            //ローカル通知登録用の日付をData型でセットする
                            self.utcDate = Date(timeInterval: 0, since: dateString)

                            //UTC + 9(Japan) 表示用の日付（日本時間）をセットする
                            self.addedDate = Date(timeInterval: 60*60*9*1, since: dateString)
                            print("addedDate:\(String(describing: self.addedDate))")
                            print("formatterString:\(formatterString.string(from: self.addedDate)))")
                            
                            //ID,LaunchDate added to struct
                            self.notificationDate.append(StructNotificationDate(id: launch.id,
                                                                launchData: self.utcDate,
                                                                rocketName: launch.name))
                            print("notificationDate - struct: \(self.notificationDate)")
                            
                            //LaunchDate,RocketName added to struct for display on PlansView
                            self.viewRocketPlanData.append(StructViewPlans(
                                                        launchData: self.addedDate,
                                                        rocketName: launch.name))
                            print("viewRocketPlanData - struct: \(self.viewRocketPlanData)")

                        }else{
                            print("dateString is nil")
                        }
                    }

                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
        
        // 登録IDをstructへ登録
        self.notificationIdData.append(StructNotificationId(id: notifyRocketInfomation[0].id,
                                                              notificationId: identifier
                                                              ))
        
        print("Notification - notificationIdData : \(self.notificationIdData)")
        
        // 通知情報のstructをUserDefaultsへ保存
        let notifyRocketIndivisualInfomation =
            self.notificationDate.filter({$0.id == forNotificationId})
        if let encoded = try? encoderForUserdDefaults.encode(notifyRocketIndivisualInfomation[0]) {
            defaultsForRocketNotification.set(encoded, forKey: "RokcetNotify+\(forNotificationId ?? 0)")
        }
        
        print("Userdefaults - defaults : \(defaultsForRocketNotification)")
        
        // UserDefaultsから通知情報を取得
        if let savedPerson = defaultsForRocketNotification.object(
                forKey: "RokcetNotify+\(forNotificationId ?? 0)") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(StructNotificationDate.self, from: savedPerson) {
                print("Userdefaults - RokcetNotify : \(loadedPerson.rocketName)")
            }
        }
        
        print("ListViewController - notificationRocket End")
    }
    
    //ロケット情報の通知情報を削除する
    func notificationRocketRemove() throws{

        print("ListViewController - In notificationRocketRemove Start")

        // Fetal Error Logic
//        var notifyRocketInfomation =
//            self.notificationIdData.filter({$0.id == forNotificationId})
//        print("notificationRemove - RocketName: \(notificationIdData[0].notificationId)")
        
        // UserDefaultsから通知情報を取得
        var notifyRocketInfomation:String
        let center = UNUserNotificationCenter.current()

        
        if let savedPerson = defaultsForRocketNotification.object(
            forKey: "RokcetNotify+\(forNotificationId ?? 0)") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(StructNotificationId.self, from: savedPerson) {
                print("Userdefaults - RokcetNotify : \(loadedPerson.notificationId)")
                notifyRocketInfomation = loadedPerson.notificationId

                center.removeDeliveredNotifications(withIdentifiers: [notifyRocketInfomation])
            }
        }

        
        
        // 通知の削除
        
        // Fetal Error Logic
//        let center = UNUserNotificationCenter.current()
//        center.removeDeliveredNotifications(withIdentifiers: [notifyRocketInfomation[0].notificationId])
//        let center = UNUserNotificationCenter.current()
//        center.removeDeliveredNotifications(withIdentifiers: [notifyRocketInfomation])

        // UserDefaultsから通知情報を取得
        defaultsForRocketNotification.removeObject(
            forKey: "RokcetNotify+\(forNotificationId ?? 0)")
        
        print("ListViewController - In notificationRocketRemove End")

    }
    
    
    //segueで詳細画面へ情報を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
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

             
            forNotificationId = launch.id
            print("ListViewController - prepare : \(forNotificationId)")
            
            // Userdefaultsにロケット情報を登録してるか確認する
            // 登録している場合は、詳細画面のUISwitchをオンにする情報を渡す
            if (defaultsForRocketNotification.object(
                    forKey: "RokcetNotify+\(forNotificationId ?? 0)") != nil){
                controller.notifySwitch = true
            }else{
                controller.notifySwitch = false
            }

            
        }
        
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

