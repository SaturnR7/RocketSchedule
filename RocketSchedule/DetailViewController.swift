//
//  DetailViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/30.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UITableViewController {
    
    var id:Int!
    var name:String!
    var videoURL:String!
    
    let notificationCenter = NotificationCenter.default
    
    @IBAction func notificationButton(_ sender: Any) {
        
        // Notification通知を送る（通知を送りたい箇所に書く。例えば何らかのボタンを押した際の処理の中等）
        notificationCenter.post(name: .myNotificationName, object: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! CustomTableViewCellDetail
        
        cell.label1?.numberOfLines = 0
        cell.label1?.text = self.name
        cell.label2?.text = self.videoURL
        
        print("DetailViewCOntroller - id : \(id)")
        
        return cell
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        
        
        
        
    }

    @IBAction func videoLink(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: self.videoURL)! as URL,
                                  options: [:],
                                  completionHandler: nil)
        
        
    }
    
    
}

//Notification.name の拡張
extension Notification.Name {
    static let myNotificationName = Notification.Name("myNotificationName")
}
