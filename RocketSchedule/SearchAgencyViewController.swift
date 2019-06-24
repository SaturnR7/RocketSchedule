//
//  DetailViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/30.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit

class SearchAgencyViewController : UITableViewController {
    
    var items = [StructAgency]()
    var item:StructAgency?
    var count: Int = 0
    var jsonAgencies: StructAgency!
    var isAgencySearch: Bool!
    
    // For Display on PlansView
    var viewAgencies = [StructViewSearchAgency]()
    
    // チェックされたセルの位置を保存しておく辞書をプロパティに宣言
    var selectedCells = [String:Bool]()

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomSearchAgencyCell
        
        let key = "\(indexPath.section)-\(indexPath.row)"
        
        //
        if selectedCells[key] != nil{
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.labelAgency?.numberOfLines = 0
        cell.labelAgency?.text = self.viewAgencies[indexPath.row].abbrev
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        old
//        let cell = tableView.cellForRow(at:indexPath)
//
//        cell?.accessoryType = .checkmark
        
        let _cell = tableView.cellForRow(at: indexPath)
        if let cell = _cell{
            
            let key = "\(indexPath.section)-\(indexPath.row)"
            
            if cell.accessoryType == UITableViewCell.AccessoryType.none{
                
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                selectedCells[key] = true
                
            } else {
                
                cell.accessoryType = UITableViewCell.AccessoryType.none
                selectedCells.removeValue(forKey: key)
                
            }
        }
        
    }
    
    // When did deselectedrow cell checkmark none
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
//        //ols
//        let cell = tableView.cellForRow(at:indexPath)
//
//        cell?.accessoryType = .none
        
        let _cell = tableView.cellForRow(at: indexPath)
        if let cell = _cell{
            
            let key = "\(indexPath.section)-\(indexPath.row)"
            
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark{
                
                cell.accessoryType = UITableViewCell.AccessoryType.none
                selectedCells.removeValue(forKey: key)

            }
        }

        
    }
    
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        // セルの単一選択
        tableView.allowsMultipleSelection = false
        
        launchJsonDownload()
        
        
    }
    
    func launchJsonDownload(){
        
        if let url = URL(
            string: "https://launchlibrary.net/1.4/agency?limit=999999"){
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {
                    print(response)
                    
                    let testdata = String(data: data, encoding: .utf8)!
                    print("data:\(testdata)")
                    
                    print("Agencies - testdata: \(testdata)")
                    
                    if testdata.contains("None found"){
                        
                        self.count = 0
                        
                    } else {
                        
                        let json = try! JSONDecoder().decode(StructAgency.self, from: data)
                        
                        self.count = json.count
                        
                        self.jsonAgencies = json
                        
                        for agencies in json.agencies {
                            print("name:\(agencies.name)")
                            
                            self.viewAgencies.append(
                                StructViewSearchAgency(
                                    name: agencies.name,
                                    abbrev: agencies.abbrev))
                            
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let controller = segue.destination as! SearchRoketViewController
//        controller.searchStartLaunch = dateStartLaunch.text
//
//
//    }
    
    
}
