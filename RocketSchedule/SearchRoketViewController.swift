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

//class SearchRoketViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
//    let agencyArray = ["NASA", "JAXA"]
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        agencyArray.count
//    }
    
    
    @IBAction func closeSearchView(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var dateStartLaunch: UITextField!
    
    @IBOutlet weak var dateEndLaunch: UITextField!
    
    @IBOutlet weak var dataAgency: UITextField!
    
    //日付用のPickerを生成
    let datePicker = UIDatePicker()
    
    //ユーザー設定値保持クラス
    let searchValueSettings = UserDefaults()
    
    // Agency Datasource
    private let dataSource = ["すべて", "NASA", "JAXA"]
    
    // Agency Picker
    let agencyPicker = UIPickerView()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createStartDatePicker()
        
        createEndDatePicker()
        
        createAgencyDataPicker()
        
        createAgencyDataToolbar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //設定値（前回検索履歴情報があった場合は、検索画面に値を設定
        if let settingStartDate = searchValueSettings.string(forKey: "settingStartDate"){
            dateStartLaunch.text = settingStartDate
        }
        if let settingStartDate = searchValueSettings.string(forKey: "settingEndDate"){
            dateEndLaunch.text = settingStartDate
        }
        if let settingAgency = searchValueSettings.string(forKey: "settingAgency"){
            dataAgency.text = settingAgency
        }
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

    func createAgencyDataPicker(){
        
        agencyPicker.delegate = self
        
        dataAgency.inputView = agencyPicker
//        cellSearchAgency.inputview = agencyPicker
        
    }

    func createAgencyDataToolbar(){
        
        //create a toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //add a done button on this toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (doneAgencyClicked))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        dataAgency.inputAccessoryView = toolbar
        
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
        
        // 設定値を保持
        searchValueSettings.set(dateFormatter.string(from: datePicker.date) , forKey: "settingStartDate")
        
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
        
        // 設定値を保持
        searchValueSettings.set(dateFormatter.string(from: datePicker.date) , forKey: "settingEndDate")

        print("dateEndLaunch.text: \(dateEndLaunch.text)")
        
        self.view.endEditing(true)
    }
    
    
    @objc func doneAgencyClicked(){
        
        // 設定値を保持
        searchValueSettings.set(dataAgency.text, forKey: "settingAgency")
        
        self.view.endEditing(true)
    }


    //画面遷移時に呼ばれる関数（セグエ経由で遷移先に値を渡す）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        
        let controller = segue.destination as! ResultListViewController
        controller.searchStartLaunch = dateStartLaunch.text
        controller.searchEndLaunch = dateEndLaunch.text
        controller.searchAgency = dataAgency.text

//        print("search segue : \(controller.searchStartLaunch)")
        
    }
    

}

extension SearchRoketViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        dataAgency.text = dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataSource[row]
    }
    
    
}
