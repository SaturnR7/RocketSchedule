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
    
    var name:String!
    var videoURL:String!
    
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
