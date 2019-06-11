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
    var notifySwitch:Bool!
    
//    var notificationCondition:Bool = false
    
    let notificationCenter = NotificationCenter.default
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("DetailViewController - tableView Start")

        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! CustomTableViewCellDetail
        
        cell.label1?.numberOfLines = 0
        cell.label1?.text = self.name
        cell.label2?.text = self.videoURL
        
        print("DetailViewCOntroller - tableView - id : \(id)")
        
        print("DetailViewController - tableView End")

        return cell
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("DetailViewController - viewDidLoad Start")
        
        
        
        print("DetailViewController - viewDidLoad End")

    }

    @IBAction func videoLink(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: self.videoURL)! as URL,
                                  options: [:],
                                  completionHandler: nil)
        
        
    }
    
    
}

////Notification.name の拡張
//extension Notification.Name {
//    static let myNotificationRocketAdd = Notification.Name("myNotificationRocketAdd")
//}
//
////Notification.name の拡張
//extension Notification.Name {
//    static let myNotificationRocketRemove = Notification.Name("myNotificationRocketRemove")
//}
