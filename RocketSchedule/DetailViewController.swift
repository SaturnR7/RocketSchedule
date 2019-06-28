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

class DetailViewController : UIViewController {
    
    private var state: RocketFavoriteState = RocketNotAddedAsFavorite()
    
    @IBOutlet weak var detailRocketName: UILabel!
    
    @IBOutlet weak var testDetailURL: UILabel!
    
    @IBOutlet weak var buttonFavorite: UIButton!
    
    
    @IBAction func buttonFavoriteTapped() {
        self.state.buttonFavoriteTapped(detailViewController: self)
    }
    
    
    var id:Int!
    var name:String!
    var videoURL:String!
    var notifySwitch:Bool!
    
//    var notificationCondition:Bool = false
    
    let notificationCenter = NotificationCenter.default
    
    // UserDefauls for Favorite
    public let defaultsForFavorite = UserDefaults.standard

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("DetailViewController - viewDidLoad Start")
        
        detailRocketName.text = self.name
        testDetailURL.text = self.videoURL
        
        // 画面起動時にロケットのIDがUserDefaultsに存在していれば、
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
        let id = defaultsForFavorite.integer(forKey: "FavoriteID+\(self.id)")
        print("DetailViewController - checkExistFavorite - ID: \(id)")
        
        // If ID not exist in UserDefaults State set RocketAddedAsFavorite
        if id != 0 {
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
        defaultsForFavorite.set(self.id, forKey: "FavoriteID+\(self.id)")

        print("DetailViewController - addafavorite - defaultsForFavorite: \(defaultsForFavorite.integer(forKey: "FavoriteID+\(self.id)"))")

        print("DetailViewController - OUT - addafavorite")

    }
    
    // Rocket remove favorite
    func removeFavorite(){
        
        print("DetailViewController - IN - removeFavorite")

        // do something
        defaultsForFavorite.removeObject(forKey: "FavoriteID+\(self.id)")
        
        print("DetailViewController - removeFavorite - defaultsForFavorite: \(defaultsForFavorite.integer(forKey: "FavoriteID+\(self.id)"))")
        
        print("DetailViewController - OUT - removeFavorite")

    }

    @IBAction func videoLink(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: self.videoURL)! as URL,
                                  options: [:],
                                  completionHandler: nil)
        
        
    }
    
    
}
