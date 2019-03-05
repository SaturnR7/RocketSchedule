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
    
    //日付用のPickerを生成
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDataPicker()
        
        
    }
    
    
    func createDataPicker(){
        
        //format the display of our datapicker
        datePicker.datePickerMode = .date
        
        //日付用のPickerをテキストに割当
        dateStartLaunch.inputView = datePicker
        
        //create a toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //add a done button on this toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (doneClicked))
        toolbar.setItems([doneButton], animated: true)
        
        dateStartLaunch.inputAccessoryView = toolbar
        
    }
    
    @objc func doneClicked(){
        
        //format the date display in textfield
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateStartLaunch.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    //画面遷移時に呼ばれる関数（セグエ経由で遷移先に値を渡す）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let controller = segue.destination as! ResultListViewController
        controller.searchStartLaunch = dateStartLaunch.text
        
    }
    

}
