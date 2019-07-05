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
    
    @IBOutlet weak var buttonFavorite: UIButton!
    
    
    @IBAction func buttonFavoriteTapped() {
        self.state.buttonFavoriteTapped(detailViewController: self)
    }
    
    
    var id: Int = 0
    var name: String = ""
    var windowStart: String = ""
    var windowEnd: String = ""
    var videoURL: String!
    var notifySwitch: Bool!
    
//    var notificationCondition:Bool = false
    
    let notificationCenter = NotificationCenter.default
    
    // UserDefauls for Favorite
    // Comment. reason: Data using RealmDB
//    public let defaultsForFavorite = UserDefaults.standard
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("DetailViewController - viewDidLoad Start")
        
        detailRocketName.text = self.name
        testDetailURL.text = self.videoURL
        
        // 画面起動時にロケットのIDがRealmに存在していれば、
        // stateにRocketAddedAsFavoriteクラスを入れる必要がある。
        checkExistFavorite()
        
        print("DetailViewController - viewDidLoad End")

    }
    
    // Set to state
    func setState(state: RocketFavoriteState){
        self.state = state
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
        
        author.id = self.id
        author.rocketName = self.name
        if self.videoURL == nil{
            self.videoURL = "Empty"
        }
        author.windowStart = self.windowStart
        author.windowEnd = self.windowEnd
        author.videoURL = self.videoURL
        
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
        
        UIApplication.shared.open(URL(string: self.videoURL)! as URL,
                                  options: [:],
                                  completionHandler: nil)
        
        
    }
    
    
}
