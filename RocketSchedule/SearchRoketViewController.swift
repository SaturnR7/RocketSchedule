//
//  SearchRoketViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/03/05.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit

class SearchRoketViewController: UIViewController {
    
    @IBAction func closeSearchView(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var dateStartLaunch: UITextField!
    
    @IBOutlet weak var dateEndLaunch: UITextField!
    
    //日付用のPickerを生成
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createStartDatePicker()
        
        createEndDatePicker()
        
        
    }
    
    
    func createStartDatePicker(){
        
        //format the display of our datapicker
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ja_JP")
        
        //日付用のPickerをテキストに割当
        dateStartLaunch.inputView = datePicker
        
        //create a toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //add a done button on this toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (doneStartDayClicked))
        toolbar.setItems([doneButton], animated: true)
        
        dateStartLaunch.inputAccessoryView = toolbar
        
    }
    
    func createEndDatePicker(){
        
        //format the display of our datapicker
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ja_JP")
        
        //日付用のPickerをテキストに割当
        dateEndLaunch.inputView = datePicker
        
        //create a toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //add a done button on this toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (doneEndDayClicked))
        toolbar.setItems([doneButton], animated: true)
        
        dateEndLaunch.inputAccessoryView = toolbar
        
    }

    @objc func doneStartDayClicked(){
        
        //format the date display in textfield
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
        
        print("datePcker.date : \(datePicker.date)")
        
        // Search StartDay to Display
        dateStartLaunch.text = dateFormatter.string(from: datePicker.date)
        
        print("dateStartLaunch.text: \(dateStartLaunch.text)")
        
        self.view.endEditing(true)
    }
    
    @objc func doneEndDayClicked(){
        
        //format the date display in textfield
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //        dateFormatter.dateStyle = .medium
        //        dateFormatter.timeStyle = .none
        
        print("datePcker.date : \(datePicker.date)")
        
        // Search StartDay to Display
        dateEndLaunch.text = dateFormatter.string(from: datePicker.date)
        
        print("dateEndLaunch.text: \(dateEndLaunch.text)")
        
        self.view.endEditing(true)
    }
    

    //画面遷移時に呼ばれる関数（セグエ経由で遷移先に値を渡す）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        
        let controller = segue.destination as! ResultListViewController
        controller.searchStartLaunch = dateStartLaunch.text
        controller.searchEndLaunch = dateEndLaunch.text
        
//        print("search segue : \(controller.searchStartLaunch)")
        
    }
    

}
