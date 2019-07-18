//
//  DetailViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/30.
//  Copyright © 2019 zilch. All rights reserved.
//
//  Launch Result Detail View (From Launch Result View)

import Foundation
import UIKit
import RealmSwift

class DetailViewController : UIViewController {
    
    private var state: RocketFavoriteState = RocketNotAddedAsFavorite()
    
    @IBOutlet weak var detailRocketName: UILabel!
    
    @IBOutlet weak var testDetailURL: UILabel!
    
    @IBOutlet weak var labelLaunchDate: UILabel!
    
    @IBOutlet weak var labelLaunchTime: UILabel!
    
    @IBOutlet weak var buttonFavorite: UIButton!
    
    
    @IBAction func buttonFavoriteTapped() {
        self.state.buttonFavoriteTapped(detailViewController: self)
    }
    
    
    var id: Int = 0
    var name: String = ""
    var launchDate: Date!
    var windowStart: String = ""
    var windowEnd: String = ""
//    var videoURL: String!
    var videoURL: [String]?
    var notifySwitch: Bool!
    
//    var notificationCondition:Bool = false
    
    let notificationCenter = NotificationCenter.default
    
    // UserDefauls for Favorite
    // Comment. reason: Data using RealmDB
//    public let defaultsForFavorite = UserDefaults.standard
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("DetailViewController - viewDidLoad Start")
       
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        self.navigationController?.navigationBar.tintColor = .white
        
        detailRocketName.text = self.name
        
        
        // Launch Date
        let formatterLaunchDate = DateFormatter()
        formatterLaunchDate.timeZone = TimeZone(identifier: "UTC")
        formatterLaunchDate.locale = Locale(identifier: "ja_JP")
        formatterLaunchDate.dateStyle = .full
        formatterLaunchDate.timeStyle = .none
        labelLaunchDate.text? = "\(formatterLaunchDate.string(from: self.launchDate))"
//        labelLaunchDate.text = self.windowStart

        // Launch Time
        let formatterLaunchTime = DateFormatter()
        formatterLaunchTime.timeZone = TimeZone(identifier: "UTC")
        formatterLaunchTime.locale = Locale(identifier: "ja_JP")
        formatterLaunchTime.dateStyle = .none
        formatterLaunchTime.timeStyle = .medium
        labelLaunchTime.text? = "\(formatterLaunchTime.string(from: self.launchDate))"
        
        testDetailURL.text = self.videoURL?[0]
        
        // 画面起動時にロケットのIDがRealmに存在していれば、
        // stateにRocketAddedAsFavoriteクラスを入れる必要がある。
        checkExistFavorite()
        
        print("DetailViewController - viewDidLoad End")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 画面起動時にロケットのIDがRealmに存在していれば、
        // stateにRocketAddedAsFavoriteクラスを入れる必要がある。
//        checkExistFavorite()
        
        // ■■■以下の処理を実装する■■■
        // 当画面に遷移した時、
        // 当画面のロケット情報がお気に入り画面のお気に入り情報に
        // 登録しているかRealmで存在チェックする
        // 存在している場合：stateモードを削除モード（RocketAddedAsFavorite）にする
        // 存在していない場合：stateモードを追加モード（RocketNotAddedAsFavorite）にする
        if !isFavoriteDataExist(){
            self.setState(state: RocketNotAddedAsFavorite())
        }
        
    }
    
    // Set to state
    func setState(state: RocketFavoriteState){
        self.state = state
    }
    
    // お気に入り情報に当画面のロケット情報が登録されているかチェック
    func isFavoriteDataExist() -> Bool{
        
        print("FavoriteListView - IN - isFavoriteDataExist")

        // Realm
        let realm = try! Realm()
        
        let filterRealm = realm.objects(FavoriteObject.self).filter("id = \(self.id)")
        
        if filterRealm.count == 0{
            print("FavoriteListView - OUT - isFavoriteDataExist - return: false")
            return false
        } else {
            print("FavoriteListView - OUT - isFavoriteDataExist - return: true")
            return true
        }
        
    }

    
    // Check exist ID in UserDefaults
    func checkExistFavorite(){
        
        print("DetailViewController - IN - checkExistFavorite")

        // write check logic
        
        // Comment. reason: Data using RealmDB
//        let id = defaultsForFavorite.integer(forKey: "FavoriteID+\(self.id)")
        
        // Realm Data Check
        let realm = try! Realm()
        let filterRealm = realm.objects(FavoriteObject.self).filter("id = \(self.id)")
        

        print("DetailViewController - checkExistFavorite - ID: \(id)")
        
        // If ID not exist in Realm State set RocketAddedAsFavorite
        if filterRealm.count != 0 {
            print("DetailViewController - checkExistFavorite - IN - IF")
            state = RocketAddedAsFavorite()
            print("DetailViewController - checkExistFavorite - OUT - IF")
        }
        
        print("DetailViewController - OUT - checkExistFavorite")

    }
    
    // Rocket add favorite
    func addafavorite(){
        
        print("DetailViewController - IN - addafavorite")

        // do something
        
        // Comment. reason: Data using RealmDB
//        defaultsForFavorite.set(self.id, forKey: "FavoriteID+\(self.id)")
//        print("DetailViewController - addafavorite - defaultsForFavorite: \(defaultsForFavorite.integer(forKey: "FavoriteID+\(self.id)"))")
        
        // Favorite Data add to Realm
        // Raalm For Favorite
        let author = FavoriteObject()
        
        // Date Formatter Declare
        let formatterString = DateFormatter()

        author.id = self.id
        author.rocketName = self.name
        if self.videoURL == nil{
//            self.videoURL = "Empty"
            self.videoURL?[0] = "Empty"
        }

        // launchDate add to author as String because launchDate declaring Date type
        formatterString.timeZone = TimeZone(identifier: "JST")
        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatterString.locale = Locale(identifier: "ja_JP")
        formatterString.dateStyle = .full
        formatterString.timeStyle = .medium
        author.windowStart = formatterString.string(from: self.launchDate)
        author.windowStart = self.windowStart

        author.windowEnd = self.windowEnd
//        author.videoURL = self.videoURL
        author.videoURL = self.videoURL?[0] ?? ""

        print("DetailViewController - addafavorite - self.name: \(self.name)")
        print("DetailViewController - addafavorite - self.windowStart: \(self.windowStart)")

        // AddTime set to author
        let addedDate = Date()
        formatterString.timeZone = TimeZone(identifier: "JST")
        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatterString.locale = Locale(identifier: "ja_JP")
        formatterString.dateStyle = .full
        formatterString.timeStyle = .medium
        author.addedDate = formatterString.string(from: addedDate)
        
        print("DetailViewController - addafavorite - author.addedDate: \(author.addedDate)")
        
        author.launchDate = self.launchDate

        let realm = try! Realm()
        try! realm.write {
            realm.add(author)
        }

        print("DetailViewController - addafavorite - realm:  \(realm.objects(FavoriteObject.self))")

        print("DetailViewController - OUT - addafavorite")

    }
    
    // Rocket remove favorite
    func removeFavorite(){
        
        print("DetailViewController - IN - removeFavorite")

        // do something
        // Comment. reason: Data using RealmDB
//        defaultsForFavorite.removeObject(forKey: "FavoriteID+\(self.id)")
//        print("DetailViewController - removeFavorite - defaultsForFavorite: \(defaultsForFavorite.integer(forKey: "FavoriteID+\(self.id)"))")
        
        
        // Favorite Data remove from Realm
        let realm = try! Realm()
//        let queryId = self.id
//        var queryId: Int!
//        if let id = self.id{
//            queryId = id
//        }
        print("DetailViewController - removeFavorite - queryId:  \(self.id)")
//        print("DetailViewController - removeFavorite - queryId:  \(queryId)")

//        let filterRealm = realm.objects(FavoriteObject.self).filter("id = 1848")
        let filterRealm = realm.objects(FavoriteObject.self).filter("id = \(self.id)")

        print("DetailViewController filterRealm[0].id: \(filterRealm[0].id)")
        print("DetailViewController - removeFavorite - filterRealmCount:  \(filterRealm.count)")
        
        try! realm.write {
            realm.delete(filterRealm)
        }

        print("DetailViewController - removeFavorite - realm:  \(realm.objects(FavoriteObject.self))")

        
        print("DetailViewController - OUT - removeFavorite")

    }

    @IBAction func videoLink(_ sender: Any) {
        
//        UIApplication.shared.open(URL(string: self.videoURL)! as URL,
//                                  options: [:],
//                                  completionHandler: nil)
        UIApplication.shared.open(URL(string: self.videoURL?[0] ?? "")! as URL,options: [:],completionHandler: nil)

        
    }
    
    
}
