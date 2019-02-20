//
//  ListViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/13.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    
    var items = [Launch]()
    var item:Launch?
    var count: Int = 0
    var jsonLaunches: Launch!
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        print("count:\(count)")
        return count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        print("launches.name\(self.jsonLaunches.launches[indexPath.row].name)")
        //        cell.textLabel?.numberOfLines = 0
        //        cell.textLabel?.text = "\(self.jsonLaunches.launches[indexPath.row].name)"
        
        // calendarを日付文字列だ使ってるcalendarに設定
        let formatterString = DateFormatter()
        //        formatterString.calendar = Calendar(identifier: .gregorian)
//        formatterString.timeZone = TimeZone.current
//        formatterString.locale = Locale(identifier: "UTC")
//        formatterString.locale = Locale.current
        //TimeZoneはUTCにしなければならない。
        //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
        //日付を返してしまうため。
        formatterString.timeZone = TimeZone(identifier: "UTC")
        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let jsonDate = self.jsonLaunches.launches[indexPath.row].windowstart
        print ("jsonDate:\(jsonDate)")
        
        if let dateString = formatterString.date(from: jsonDate){
            print("dateString:\(String(describing: dateString))")
            
            formatterString.locale = Locale(identifier: "ja_JP")
//            formatterString.locale = Locale.current
            formatterString.dateStyle = .full
            formatterString.timeStyle = .medium

            //UTC + 9(Japan)
            let addedDate = Date(timeInterval: 60*60*9*1, since: dateString)
            print("addedDate:\(addedDate)")
            
            print("formatterString:\(formatterString.string(from: addedDate)))")
            
            cell.labelLaunchTime?.numberOfLines = 0
            cell.labelLaunchTime?.text = "\(formatterString.string(from: addedDate))"
        }else{
            print("dateString is nil")
        }

        
//        cell.labelLaunchTime?.numberOfLines = 0
//        cell.labelLaunchTime?.text = "\(self.jsonLaunches.launches[indexPath.row].windowstart)"
        cell.labelRocketName?.numberOfLines = 0
        cell.labelRocketName?.text = "\(self.jsonLaunches.launches[indexPath.row].name)"
        
        return cell
    }
    
    

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        launchJsonDownload()
//
//        self.tableView.reloadData()
//    }

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)

        launchJsonDownload()
        
        //タイムゾーン（地域）の取得
        print("regioncode:\(TimeZone.current.localizedName(for: .standard, locale: .current) ?? "")")
        print("Timezone:\(TimeZone.current)")
        print("TimezoneAutoupdatingCurrent:\(TimeZone.autoupdatingCurrent)")
        
        //日付の加算テスト
        let now = Date() // Dec 27, 2015, 8:24 PM
        print("now:\(now)")
        // 60秒*60分*24時間*7日 = 1週間後の日付
        let date1 = Date(timeInterval: 60*60*9*1, since: now) // Jan 3, 2016, 8:24 PM
        print("date1:\(date1)")
        
        
        // styleを使う
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let localizedString = formatter.string(from: date1)
        
        print("localizedString:\(localizedString)")
        
        
//        // calendarを日付文字列だ使ってるcalendarに設定
//        let formatterString = DateFormatter()
//        // dateFormatをAPIのフォーマットに合わせて設定(rfc3339)
//        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        // localeをen_US_POSIXに設定
//        formatterString.locale = Locale(identifier: "ja_JP")
//        formatterString.calendar = Calendar(identifier: .gregorian)
//        let dateString = formatterString.date(from: "2018-06-16 10:27:30")
//
//        if let test = dateString{
//            print("dateString:\(String(describing: test))")
//        }else{
//            print("dateString is nil")
//        }


    }


    func launchJsonDownload(){
        
        if let url = URL(
            string: "https://launchlibrary.net/1.4/launch"){
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {
                    print(response)
                    
                    let testdata = String(data: data, encoding: .utf8)!
                    print("data:\(testdata)")

                    let json = try! JSONDecoder().decode(Launch.self, from: data)
                    
                    self.count = json.count
                    
                    self.jsonLaunches = json
                    
                    for launch in json.launches {
                        print("name:\(launch.name)")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } else {
                    print(error ?? "Error")
                }
            })
            

            task.resume()

            }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let launch = self.jsonLaunches.launches[indexPath.row]
            let controller = segue.destination as! DetailViewController
            controller.title = "Detail"
            controller.name = launch.name
            controller.videoURL = launch.vidURLs?[0]
            
            
            
        }
        
    }
    
}

