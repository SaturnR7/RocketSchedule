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


    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        print("tableView numberOfRowsInSection start")

        print("count:\(count)")
        
        print("tableView numberOfRowsInSection end")

        return count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("tableView cellForRowAt start")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        let formatterString = DateFormatter()
        //TimeZoneはUTCにしなければならない。
        //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
        //日付を返してしまうため。
        formatterString.timeZone = TimeZone(identifier: "UTC")
        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatterString.locale = Locale(identifier: "ja_JP")
        formatterString.dateStyle = .full
        formatterString.timeStyle = .medium

        cell.labelLaunchTime?.numberOfLines = 0
        cell.labelLaunchTime?.text = "\(formatterString.string(from: viewRocketPlanData[indexPath.row].launchDate))"
        
        cell.labelRocketName?.numberOfLines = 0
        cell.labelRocketName?.text = "\(self.viewRocketPlanData[indexPath.row].rocketName)"
        
        print("tableView cellForRowAt end")

        return cell
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad start")

        // NotificationCenterに登録する
        // Notificationのcatch関数は別に宣言
        notificationCenter.addObserver(self, selector: #selector(catchNotification(notification:)), name: .myNotificationName, object: nil)


        print("viewDidLoad start")

        launchJsonDownload()
        
        
        //テーブルビューの pull-to-refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
//        self.tableView.reloadData()
        
        print("viewDidLoad end")
    }
    
    
    //リフレッシュ処理
    @objc func refresh(sender: UIRefreshControl) {
        print("In refresh Start")
        //Json再取得
        launchJsonDownload()
        
        sender.endRefreshing()
        
        print("In refresh End")
    }
    

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)

        print("viewDidAppear start")

        print("==jsonLaunches==\(notificationDate)")
        
        print("forNotificationId - \(forNotificationId)")
//
//        if forNotificationId != nil{
//            notificationRocket()
//        }

        print("viewDidAppear end")

    }


    func launchJsonDownload(){
        
        print("launchJsonDownload start")
        
        if let url = URL(
            string: "https://launchlibrary.net/1.4/launch?next=999999"){
            
            print("launchJsonDownload start inside URL")

            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {

                    print("launchJsonDownload start inside URLSession")
                    
                    print(response)
                    
//                    let testdata = String(data: data, encoding: .utf8)!
//                    print("data:\(testdata)")

                    let json = try! JSONDecoder().decode(Launch.self, from: data)
                    
                    self.count = json.count
                    
                    self.jsonLaunches = json
                    
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
                        print ("jsonDate:\(jsonDate)")
                        
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

        print("launchJsonDownload end")
    }
    
    func notificationRocket(){
        
        print("In notificationRocket Start")

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

        print("In notificationRocket End")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let launch = self.jsonLaunches.launches[indexPath.row]
            let controller = segue.destination as! DetailViewController
            controller.title = "Detail"
            controller.id = launch.id
            controller.name = launch.name
            controller.videoURL = launch.vidURLs?[0]
            
            forNotificationId = launch.id
            print("ListViewController - prepare : \(forNotificationId)")
            
            
            
        }
        
    }
    
    //Notification受け取ったらその後に実行したい処理を書く
    @objc func catchNotification(notification: Notification) -> Void {
        print("Catch notification")
        
        // do something
        
        print("catchNotification - forNotificationId : \(forNotificationId)")
        
        //直近のロケットの打ち上げ予定を通知する
        print("In catchNotification Start")
        self.notificationRocket()
        print("In catchNotification End")

    }
    
}

