//
//  FavoriteListView.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/06/28.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class FavoriteListView: UITableViewController {
    
    var items = [Launch]()
    var item:Launch?
    var count: Int = 0
    var jsonLaunches: Launch!
    var isAgencySearch: Bool! = false
    
    // Usage of URL "https://launchlibrary.net/1.4/launch?startdate=1907-01-12&enddate=1969-09-20&limit=999999"
    let urlStringOf1: String = "https://launchlibrary.net/1.4/launch"
    let urlStringOf2: String = "?startdate="
    let urlStringOfDefaultStartDate: String = "1907-01-12"
    var urlStringOfSearchStartDate: String = "1907-01-12"
    let urlStringOf3: String = "&enddate="
    let urlStringOfDefaultEndDate: String = "1969-09-20"
    var urlStringOfSearchEndDate: String = "1969-09-20"
    let urlStringOfLimit: String = "&limit=999999"
    let urlStringOfAgency: String = "&agency="
    var urlStringOfAgencyValue: String!
    let urlStringOfVerbose: String = "&mode=verbose"
    
    var url: String!
    
    //search of Rocket
    var searchStartLaunch: String?
    var searchEndLaunch: String?
    var searchAgency: String?
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        print("count:\(count)")
        return count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        print("launches.name\(self.jsonLaunches.launches[indexPath.row].name)")

        let formatterString = DateFormatter()

        //TimeZoneはUTCにしなければならない。
        //理由は、UTCに指定していないと、
        //DateFormatter.date関数はcurrentのゾーンで
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
        
        cell.labelRocketName?.numberOfLines = 0
        cell.labelRocketName?.text = "\(self.jsonLaunches.launches[indexPath.row].name)"
        
        return cell
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //realm test
        let author = FavoriteObject()
        author.title = "Realm Test"
        let realm = try! Realm()
        try! realm.write {
            realm.add(author)
        }

        
        launchJsonDownload()

        //テーブルビューの pull-to-refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)

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
        
        
        // UserDefaults Test
        // 1829
        var test = DetailViewController()
        let getDefault = test.defaultsForFavorite.integer(forKey: "FavoriteID+\(1829)")
        print("FavoriteListView - viewDidAppear - test.defaultsForFavorite: \(test.defaultsForFavorite)")
        print("FavoriteListView - viewDidAppear - getDefault: \(getDefault)")

    }
    
    func launchJsonDownload(){
        
        if let url = URL(
                        string: "https://launchlibrary.net/1.4/launch?startdate=1907-01-12&enddate=1969-09-20&limit=999999"){
//            string: "\(url!)"){
        
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {
                    print(response)
                    
                    let testdata = String(data: data, encoding: .utf8)!
                    print("data:\(testdata)")
                    
                    if testdata.contains("None found"){
                        
                        self.count = 0
                        
                    } else {
                        
                        let json = try! JSONDecoder().decode(Launch.self, from: data)
                        
                        self.count = json.count
                        
                        self.jsonLaunches = json
                        
                        for launch in json.launches {
                            print("name:\(launch.name)")
                        }
                        
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
            controller.id = launch.id
            controller.name = launch.name
            controller.videoURL = launch.vidURLs?[0]
            
        }
        
    }
    
}


