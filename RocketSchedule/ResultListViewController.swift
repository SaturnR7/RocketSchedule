//
//  ListViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/13.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit

class ResultListViewController: UITableViewController {
    
    var items = [Launch]()
    var item:Launch?
    var count: Int = 0
    var jsonLaunches: Launch!
    var isAgencySearch: Bool! = false
    var addedDate:Date!

    
    // Usage of URL "https://launchlibrary.net/1.4/launch?startdate=1907-01-12&enddate=1969-09-20&limit=999999"
    let urlStringOf1: String = "https://launchlibrary.net/1.4/launch"
    let urlStringOf2: String = "&startdate="
    let urlStringOfDefaultStartDate: String = "1907-01-12"
    var urlStringOfSearchStartDate: String = "1907-01-12"
    let urlStringOf3: String = "&enddate="
    let urlStringOfDefaultEndDate: String = "1969-09-20"
    var urlStringOfSearchEndDate: String = "1969-09-20"
    let urlStringOfLimit: String = "&limit=999999"
    let urlStringOfAgency: String = "&agency="
    var urlStringOfAgencyValue: String!
    let urlStringOfVerbose: String = "?mode=verbose"
    
    var url: String!
    
    //search of Rocket
    var searchStartLaunch = ""
    var searchEndLaunch = ""
    var searchAgency = ""
    
    //For Display on PlansView
    var viewRocketPlanData = [StructViewPlans]()
    
    // URL userdefaults
    var searchURL = UserDefaults()
    
    @IBAction func searchRocket(_ sender: Any) {
        
        //        let SearchRoketViewController = storyboard?.instantiateViewController(withIdentifier: "SearchRoketViewController") as! SearchRoketViewController
        //
        //        present(SearchRoketViewController, animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "toSearch", sender: nil)
        
    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        print("count:\(count)")
        return count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("ResultListViewController - tableview - start")
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        //TimeZoneはUTCにしなければならない。
        //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
        //日付を返してしまうため。
        let formatterString = DateFormatter()
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

        
        //        cell.labelLaunchTime?.numberOfLines = 0
        //        cell.labelLaunchTime?.text = "\(self.jsonLaunches.launches[indexPath.row].windowstart)"
        cell.labelRocketName?.numberOfLines = 0
        cell.labelRocketName?.text = "\(self.jsonLaunches.launches[indexPath.row].name)"

        print("ResultListViewController - tableview - end")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // cell borderline size
        tableView.separatorInset =
            UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);
        
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        print("ResultListViewController - viewDidAppear - Start")
        
        print("In viewDidAppear - searchAgency: \(searchAgency)")

        print("searchStartLaunch: \(searchStartLaunch)")
        print("searchEndLaunch: \(searchEndLaunch)")

        
        var isDefaultSearch = false
        
        //test
        if searchStartLaunch == "" {
            print("searchStartLaunch : \(searchStartLaunch)")
            
            // 初回起動時はtrueになる
            isDefaultSearch = true
            
            urlStringOfSearchStartDate = urlStringOfDefaultStartDate
        } else {
            urlStringOfSearchStartDate = searchStartLaunch
        }
        
        if searchEndLaunch == "" {
            print("searchEndLaunch : \(searchEndLaunch)")
            urlStringOfSearchEndDate = urlStringOfDefaultEndDate
        } else {
            urlStringOfSearchEndDate = searchEndLaunch
        }
        
        // 機関が選択された場合は、URLに機関項目を設定する
        //        if searchAgency != "すべて"{
        //            urlStringOfAgencyValue = searchAgency
        //            print("ResultListViewController - viewDidAppear - urlStringOfAgencyValue: \(urlStringOfAgencyValue)")
        //
        //            isAgencySearch = true
        //
        //        } else {
        //
        //            isAgencySearch = false
        //        }
        if searchAgency == ""{
            isAgencySearch = false
        }else{
            if searchAgency != "すべて"{
                urlStringOfAgencyValue = searchAgency
                print("ResultListViewController - viewDidAppear - urlStringOfAgencyValue: \(urlStringOfAgencyValue)")
                
                isAgencySearch = true
            }else{
                isAgencySearch = false
            }
        }
        
        
        // 検索画面において機関項目を選択した場合は、機関項目を付加したURLを発行する
        if isAgencySearch{
            
            url = urlStringOf1 + urlStringOfVerbose + urlStringOf2 + urlStringOfSearchStartDate + urlStringOf3 + urlStringOfSearchEndDate + urlStringOfAgency + urlStringOfAgencyValue + urlStringOfLimit
            
        } else {
            
            url = urlStringOf1 + urlStringOfVerbose + urlStringOf2 + urlStringOfSearchStartDate + urlStringOf3 + urlStringOfSearchEndDate + urlStringOfLimit
        }
        
        // 初回起動時に前回検索していた場合は、前回検索したURLを使用する
        if isDefaultSearch{
            if searchURL.string(forKey: "settingURL") != nil{
                print("searchURL Userdefault: \(searchURL.string(forKey: "settingURL"))")
                url = searchURL.string(forKey: "settingURL")
            }
        }
        
        
        print("ResultListViewController - viewDidAppear - RequestURL: \(url)")
        
        // URLを保持
        searchURL.set(url , forKey: "settingURL")
        
        // URL検索
        launchJsonDownload()
        
//        //タイムゾーン（地域）の取得
//        print("regioncode:\(TimeZone.current.localizedName(for: .standard, locale: .current) ?? "")")
//        print("Timezone:\(TimeZone.current)")
//        print("TimezoneAutoupdatingCurrent:\(TimeZone.autoupdatingCurrent)")
//
//        //日付の加算テスト
//        let now = Date() // Dec 27, 2015, 8:24 PM
//        print("now:\(now)")
//        // 60秒*60分*24時間*7日 = 1週間後の日付
//        let date1 = Date(timeInterval: 60*60*9*1, since: now) // Jan 3, 2016, 8:24 PM
//        print("date1:\(date1)")
//
//
//        // styleを使う
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .medium
//        let localizedString = formatter.string(from: date1)
//
//        print("localizedString:\(localizedString)")
        
        
//        self.tableView.reloadData()
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)

        print("ResultListViewController - viewDidAppear - End")
    }
    
    
    func launchJsonDownload(){
        
        if let url = URL(
            //            string: "https://launchlibrary.net/1.4/launch?startdate=1907-01-12&enddate=1969-09-20&limit=999999"){
            string: "\(url!)"){
            
            print("ResultListViewController - launchJsonDownload - URL: \(url)")
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {
                    print(response)
                    
                    let testdata = String(data: data, encoding: .utf8)!
//                    print("data:\(testdata)")
                    
                    if testdata.contains("None found"){
                        
                        self.count = 0
                        
                    } else {
                        
                        let json = try! JSONDecoder().decode(Launch.self, from: data)
                        
                        self.count = json.count
                        
                        self.jsonLaunches = json

//                        print("JSON Data: \(json)")

                        // Initialize to Struct
                        self.viewRocketPlanData = [StructViewPlans]()
                        
                        for launch in json.launches {
                            
                            // calendarを日付文字列だ使ってるcalendarに設定
                            let formatterString = DateFormatter()
                            //TimeZoneはUTCにしなければならない。
                            //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
                            //日付を返してしまうため。
                            formatterString.timeZone = TimeZone(identifier: "UTC")
//                            formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            formatterString.dateFormat = "MMMM dd, yyyy HH:mm:ss z"
                            let jsonDate = launch.windowstart
                            //                        print ("jsonDate:\(jsonDate)")
                            
                            if let dateString = formatterString.date(from: jsonDate){
//                                print("dateString:\(String(describing: dateString))")
                                
                                formatterString.locale = Locale(identifier: "ja_JP")
                                formatterString.dateStyle = .full
                                formatterString.timeStyle = .medium
                                
                                //UTC + 9(Japan) 表示用の日付（日本時間）をセットする
                                self.addedDate = Date(timeInterval: 60*60*9*1, since: dateString)
//                                print("addedDate:\(String(describing: self.addedDate))")
//                                print("formatterString:\(formatterString.string(from: self.addedDate)))")

                                //LaunchDate,RocketName added to struct for display on PlansView
                                self.viewRocketPlanData.append(StructViewPlans(
                                    launchData: self.addedDate,
                                    rocketName: launch.name))
//                                print("name:\(launch.name)")
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
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
            controller.id = launch.id
            controller.name = launch.name
            controller.rocketImageURL = launch.rocket.imageURL

            // 詳細画面にDate型の日付を渡す
            // 詳細画面での日付・時刻分け表示に都合がよいため
            controller.launchDate = viewRocketPlanData[indexPath.row].launchDate
            //            controller.windowStart = launch.windowstart
            controller.windowEnd = launch.windowend
            
            //            controller.videoURL = launch.vidURLs?[0]
            controller.videoURL = launch.vidURLs
//            if let vidURLs = launch.vidURLs{
//                controller.videoURL = vidURLs
//            }

            // Agency name send to DetailView
            if launch.location.pads[0].agencies!.count != 0{
                if let agency = launch.location.pads[0].agencies{
                    print("ListViewController - prepare - agency : \(agency[0].abbrev)")
                    controller.agency = agency[0].abbrev
                }
            }else{
                controller.agency = "機関名なし"
            }


        }
        
    }
    
}


