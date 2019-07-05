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
    
    var count: Int = 0
    var jsonLaunches: Launch!
//    var favoriteLaunches = StructRealmFavoriteData()
    var arrayFavoriteLaunches = [StructRealmFavoriteData]()
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
    
    // Realm
//    let realm = try! Realm()
    
    // Select cell swipe to the left
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell

        
        
        if editingStyle == .delete {
            
            let targetId = Int(cell.labelRocketId.text ?? "0")
            
            // Call Data Delete Func
            removeFavorite(id: targetId ?? 0)
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            
        }
        
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        print("count:\(arrayFavoriteLaunches.count)")
        return arrayFavoriteLaunches.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        // Launch Date add Local Date
        let formatterString = DateFormatter()
        //TimeZoneはUTCにしなければならない。
        //理由は、UTCに指定していないと、
        //DateFormatter.date関数はcurrentのゾーンで
        //日付を返してしまうため。
        formatterString.timeZone = TimeZone(identifier: "UTC")
        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        print ("FavoriteListView - tableView - arrayFavoriteLaunchesWindowStart:\(self.arrayFavoriteLaunches[indexPath.row].windowStart)")
        let jsonDate = self.arrayFavoriteLaunches[indexPath.row].windowStart
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
        cell.labelRocketName?.text = "\(self.arrayFavoriteLaunches[indexPath.row].rocketName)"
        
        cell.labelRocketId?.text = "\(self.arrayFavoriteLaunches[indexPath.row].id)"
        
        return cell
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // comment reason: Launch Data get from Realm
//        launchJsonDownload()
        
        // Read Realm Data
        launchDataLoad()

        //テーブルビューの pull-to-refresh
//        refreshControl = UIRefreshControl()
//        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)

    }

    //リフレッシュ処理
    @objc func refresh(sender: UIRefreshControl) {
        print("In refresh Start")

        // comment reason: Launch Data get from Realm
//        //Json再取得
//        launchJsonDownload()
        
        sender.endRefreshing()
        
        print("In refresh End")
    }
    

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        // Read Realm Data
        launchDataLoad()
        
        tableView.reloadData()
        
    }
    
    func launchDataLoad(){
        
        // Realm
        let realm = try! Realm()
        
        // Initialize to Arrya Struct
        arrayFavoriteLaunches = [StructRealmFavoriteData]()

        // Get From Realm
        let getAllDataRealm = realm.objects(FavoriteObject.self)
        
        // RealmData input to Array Struct
        for data in getAllDataRealm{
            
            arrayFavoriteLaunches.append(
                StructRealmFavoriteData(
                    id: data.id,
                    rocketName: data.rocketName,
                    windowsStart: data.windowStart,
                    windowEnd: data.windowEnd,
                    videoURL: data.videoURL
                )
            )
            
        }
        
        print("FavoriteListView - launchDataLoad - arrayFavoriteLaunches.count: \(arrayFavoriteLaunches.count)")
//        print("FavoriteListView - launchDataLoad - arrayFavoriteLaunches[0].id: \(arrayFavoriteLaunches[0].id)")
        
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

    
    // Rocket remove favorite
    func removeFavorite(id: Int){
        
        print("FavoriteListView - IN - removeFavorite")
        
        // do something
        let realm = try! Realm()
        print("DetailViewController - removeFavorite - queryId:  \(id)")
        let filterRealm = realm.objects(FavoriteObject.self).filter("id = \(id)")
        
        // Data Delete that swiped cell
        try! realm.write {
            realm.delete(filterRealm)
        }
        
        print("FavoriteListView - OUT - removeFavorite")
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
//        if let indexPath = self.tableView.indexPathForSelectedRow {
//            let launch = self.jsonLaunches.launches[indexPath.row]
//            let controller = segue.destination as! DetailViewController
//            controller.title = "Detail"
//            controller.id = launch.id
//            controller.name = launch.name
//            controller.videoURL = launch.vidURLs?[0]
//
//        }
        
    }
    
}


