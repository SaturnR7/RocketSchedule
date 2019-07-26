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
    
    @IBOutlet weak var searchLabel: UILabel!
    
    @IBOutlet weak var labelLaunch: UILabel!
    
    @IBOutlet weak var labelAgency: UILabel!
    
    //各種Pickerを生成
    let dateStartPicker = UIDatePicker()
    let dateEndPicker = UIDatePicker()
    let agencyPicker = UIPickerView()

    //ユーザー設定値保持クラス
    let searchValueSettings = UserDefaults()
    
    // Agency Datasource
    private let dataSource = [
        "すべて",
        "JAXA(日本)",
        "NASA(アメリカ)",
        "RFSA(ロシア)",
        "SPACEX"
    ]
    
    // Agencies Dictinary
    var agenciesDictionary: Dictionary<String,String> = [:]
    
    // DatePicker用前回検索履歴保持
    var dateStartLaunchText = ""
    var dateEndLaunchText = ""
    var agencyText = ""

    // Agency picker for selected history
    var forTextField = ""
    var historyRow = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 打ち上げ期間の開始日付
        createStartDatePicker()
        
        // 打ち上げ期間の終了日付
        createEndDatePicker()
        
        // 打ち上げ機関
        createAgencyDataPicker()
        createAgencyDataToolbar()
        
        // Value of Agency DataPicker
        makeAgenciesDictionary()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 初回イントール時は日付にデフォルト値を設定する
        // 開始日：本日の７日前
        // 終了日：本日
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let todayString = dateFormatter.string(from: today)
        // -60秒*60分*24時間*7日 = 1週間前の日付
        let pastDate = Date(timeInterval: -60*60*24*7, since: today)
        let pastDateString = dateFormatter.string(from: pastDate)

        // 設定値（前回検索履歴情報があった場合は、検索画面に値を設定
        if let settingStartDate = searchValueSettings.string(forKey: "settingStartDate"){
            dateStartLaunch.text = settingStartDate
            dateStartLaunchText = settingStartDate
            
        }else{
            dateStartLaunch.text = pastDateString
            dateStartLaunchText = pastDateString
        }
        
        if let settingEndDate = searchValueSettings.string(forKey: "settingEndDate"){
            dateEndLaunch.text = settingEndDate
            dateEndLaunchText = settingEndDate
        }else{
            dateEndLaunch.text = todayString
            dateEndLaunchText = todayString
        }
        
        if let settingAgency = searchValueSettings.string(forKey: "settingAgency"){
            dataAgency.text = settingAgency
            agencyText = settingAgency
        }else{
            dataAgency.text = "すべて"
            agencyText = "すべて"
        }
        
        // 打ち上げ期間の開始日付
        createStartDatePicker()
        // 打ち上げ期間の終了日付
        createEndDatePicker()

        // 打ち上げ機関ピッカーのリスト内移動
        let selectedRow = searchValueSettings.integer(forKey: "selectedRowAgency")
        agencyPicker.selectRow(selectedRow, inComponent: 0, animated: false)

        // レイアウト表示（storyboardに組み込むと早く表示されてしまうためダサい）
        labelLaunch.text = "打ち上げ期間"
        searchLabel.text = "|"
        labelAgency.text = "機関"
        
    }
    
    func createStartDatePicker(){
        
        print("SearchRoketViewController - IN - createStartDatePicker")

        //format the display of our datapicker
        dateStartPicker.datePickerMode = .date
        dateStartPicker.locale = Locale(identifier: "ja_JP")
        
        // 前回の検索日付をDatePickerに設定
        // この処理をしないと、前回検索日付をタップしてもDatePickerが現在日付を表示してしまうため
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        print("SearchRoketViewController - createStartDatePicker - dateStartLaunch.text: \(String(describing: dateStartLaunch.text))")
        print("SearchRoketViewController - createStartDatePicker - dateStartLaunchText: \(dateStartLaunchText)")
        if let date = dateFormatter.date(from: "\(dateStartLaunchText)") {
            print("SearchRoketViewController - createStartDatePicker - date: \(date)")
            dateStartPicker.date = date
        }

        // DatePicker Date
        dateStartPicker.minimumDate = dateFormatter.date(from: "1957/05/15")
        dateStartPicker.maximumDate = Date()
        
        //日付用のPickerをテキストに割当
        dateStartLaunch.inputView = dateStartPicker
        
        //create a toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //add a done button on this toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (doneStartDayClicked))
        
        // Flexible Space Bar Button Item
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        //add a cancel button on this toolbar
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector (cancelDateStartClicked))

        toolbar.setItems([cancelButton, flexibleItem, doneButton], animated: true)
        
        dateStartLaunch.inputAccessoryView = toolbar
        
        print("SearchRoketViewController - OUT - createStartDatePicker")

    }
    
    func createEndDatePicker(){
        
        //format the display of our datapicker
        dateEndPicker.datePickerMode = .date
        dateEndPicker.locale = Locale(identifier: "ja_JP")
        
        // 前回の検索日付をDatePickerに設定
        // この処理をしないと、前回検索日付をタップしてもDatePickerが現在日付を表示してしまうため
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let date = dateFormatter.date(from: "\(dateEndLaunchText)") {
            print("SearchRoketViewController - createStartDatePicker - date: \(date)")
            dateEndPicker.date = date
        }

        // DatePicker Date
        dateEndPicker.minimumDate = dateFormatter.date(from: "1957/05/15")
        dateEndPicker.maximumDate = Date()

        //日付用のPickerをテキストに割当
        dateEndLaunch.inputView = dateEndPicker
        
        //create a toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //add a done button on this toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (doneEndDayClicked))
        
        // Flexible Space Bar Button Item
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        //add a done button on this toolbar
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector (cancelDateEndClicked))
        
        toolbar.setItems([cancelButton, flexibleItem, doneButton], animated: true)
        
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

        // Flexible Space Bar Button Item
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        //add a done button on this toolbar
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector (cancelAgencyClicked))
        
        toolbar.setItems([cancelButton, flexibleItem, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        dataAgency.inputAccessoryView = toolbar
        
    }
    
    @objc func doneStartDayClicked(){
        
        //format the date display in textfield
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
        
        print("datePcker.date : \(dateStartPicker.date)")
        
        // Search StartDay to Display
        dateStartLaunch.text = dateFormatter.string(from: dateStartPicker.date)
        
        // 設定値を保持
        searchValueSettings.set(dateFormatter.string(from: dateStartPicker.date) , forKey: "settingStartDate")
        
        print("dateStartLaunch.text: \(dateStartLaunch.text)")
        
        self.view.endEditing(true)
    }
    
    @objc func doneEndDayClicked(){
        
        //format the date display in textfield
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        //        dateFormatter.dateStyle = .medium
        //        dateFormatter.timeStyle = .none
        
        print("datePcker.date : \(dateEndPicker.date)")
        
        // Search StartDay to Display
        dateEndLaunch.text = dateFormatter.string(from: dateEndPicker.date)
        
        // 設定値を保持
        searchValueSettings.set(dateFormatter.string(from: dateEndPicker.date) , forKey: "settingEndDate")
        
        print("dateEndLaunch.text: \(dateEndLaunch.text)")
        
        self.view.endEditing(true)
    }
    
    @objc func doneAgencyClicked(){
        
        // ピッカーで選択した機関をテキストフィールドに設定
        dataAgency.text = forTextField
        
        // 設定値を保持
        searchValueSettings.set(dataAgency.text, forKey: "settingAgency")
        
        self.view.endEditing(true)
    }
    
    // DatePickerのキャンセルボタン押下時の処理
    @objc func cancelDateStartClicked(){
        self.view.endEditing(true)
    }
    
    // DatePickerのキャンセルボタン押下時の処理
    @objc func cancelDateEndClicked(){
        self.view.endEditing(true)
    }
    
    // DatePickerのキャンセルボタン押下時の処理
    @objc func cancelAgencyClicked(){
        self.view.endEditing(true)
    }

    func makeAgenciesDictionary(){
        
        agenciesDictionary["すべて"] = "すべて"
        agenciesDictionary["JAXA(日本)"] = "JAXA"
        agenciesDictionary["NASA(アメリカ)"] = "NASA"
        agenciesDictionary["RFSA(ロシア)"] = "RFSA"
        agenciesDictionary["SPACEX"] = "SpX"

        // Test
        let test = agenciesDictionary["NASA(アメリカ)"]
        let test2 = agenciesDictionary["SPACEX"]
        print("SearchRoketViewController - AgenciesDictionary: \(test)")
        print("SearchRoketViewController - AgenciesDictionary2: \(test2)")
        
    }
    
    
    //画面遷移時に呼ばれる関数（セグエ経由で遷移先に値を渡す）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        let controller = segue.destination as! ResultListViewController
        // 遷移元に検索日付を渡すが、検索URLのパラメタ用に日付の"/"を"-"(ハイフン)に置換える
        controller.searchStartLaunch = dateStartLaunch.text?.replacingOccurrences(of: "/", with: "-")
        controller.searchEndLaunch = dateEndLaunch.text?.replacingOccurrences(of: "/", with: "-")

        // Agency DataPicker data
//        if let bindingAgency = forTextField{
            let forSearchAgency = agenciesDictionary["\(forTextField)"]
            
            print("SearchRoketViewController - prepare - forTextField: \(forTextField)")
            print("SearchRoketViewController - prepare - forSearchAgency: \(forSearchAgency)")

            controller.searchAgency = forSearchAgency
//        }
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
        
        // テキストフィールド表示用
        forTextField = dataSource[row]
        
        // 選択した項目のrow値値を保持（検索画面の前回検索履歴保持）
        // picker表示時に前回選択した項目を表示させるため
        searchValueSettings.set(row, forKey: "selectedRowAgency")

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return dataSource[row]
    }
    
    
}

