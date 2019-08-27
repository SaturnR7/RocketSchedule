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
    
    // Self Class Name
    var className: String {
        return String(describing: type(of: self)) // ClassName
    }
    
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
        
//        // 打ち上げ期間の設定値を保持
//        searchValueSettings.set(dateStartLaunch.text , forKey: "settingStartDate")
//        searchValueSettings.set(dateEndLaunch.text , forKey: "settingEndDate")
//        // 機関の設定値を保存
//        searchValueSettings.set(dataAgency.text, forKey: "settingAgency")
        // 検索項目の設定を保存
        lastSelectValueSet()

        // 検索画面を閉じる
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func buttonClear(_ sender: UIButton) {
        
        // 現在から１週間前の日付をセットする
        dateStartLaunch.text = getStringDay1weekAgo()
        // 現在日付をセットする
        dateEndLaunch.text = getStringToday()
        // 機関「すべて」をセットする
        dataAgency.text = "すべて"
        // 機関リストを先頭に移動する
        agencyPicker.selectRow(0, inComponent: 0, animated: false)

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
    var forAgencyTextField = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SearchRoketViewController - viewDidLoad - Start")
        
        // 打ち上げ期間の開始日付
        createStartDatePicker()
        
        // 打ち上げ期間の終了日付
        createEndDatePicker()
        
        // 打ち上げ機関
        createAgencyDataPicker()
        createAgencyDataToolbar()
        
        // Value of Agency DataPicker
        makeAgenciesDictionary()
        
        print("SearchRoketViewController - viewDidLoad - End")
    }
    
    // 現在の日付を取得
    func getStringToday() -> String{
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        return dateFormatter.string(from: today)
    }
    
    // 現在から１週間前の日付を取得
    func getStringDay1weekAgo() -> String{
    
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"

        // -60秒*60分*24時間*7日 = 1週間前の日付
        let pastDate = Date(timeInterval: -60*60*24*7, since: today)
        
        return dateFormatter.string(from: pastDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("SearchRoketViewController - viewDidAppear - Start")

//        // 初回イントール時は日付にデフォルト値を設定する
//        // 開始日：本日の７日前
//        // 終了日：本日
//        let today = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ja_JP")
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        let todayString = dateFormatter.string(from: today)
//
//        // -60秒*60分*24時間*7日 = 1週間前の日付
//        let pastDate = Date(timeInterval: -60*60*24*7, since: today)
//        let pastDateString = dateFormatter.string(from: pastDate)

        // 現在日付の取得
        let todayString = getStringToday()
        // 現在から１週間前の日付を取得
        let pastDateString = getStringDay1weekAgo()

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
        

        print("SearchRoketViewController - viewDidAppear - End")
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
        
        // DatePicker Background Color
        dateStartPicker.backgroundColor =
            UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        // DatePicker Text Color
        dateStartPicker.setValue(UIColor.white, forKey: "textColor")
        // Toolbar Background Color
        toolbar.barTintColor =
            UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)

        // DatePicker set to TextField
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
        
        // DatePicker Background Color
        dateEndPicker.backgroundColor =
            UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        // DatePicker Text Color
        dateEndPicker.setValue(UIColor.white, forKey: "textColor")
        // Toolbar Background Color
        toolbar.barTintColor =
            UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)

        // DatePicker set to TextField
        dateEndLaunch.inputAccessoryView = toolbar
        
    }
    
    func createAgencyDataPicker(){
        
        agencyPicker.delegate = self
        
        // DataPicker Text Color
        agencyPicker.backgroundColor =
            UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        agencyPicker.setValue(UIColor.white, forKey: "textColor")

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

        // Toolbar Background Color
        toolbar.barTintColor =
            UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)

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
        
        print("doneAgencyClicked - forAgencyTextField: \(forAgencyTextField)")

        // データピッカー表示時に、何も変更せずDoneをタップした場合は、
        // 直前の期間名を設定する。
        if forAgencyTextField == ""{
            forAgencyTextField = dataAgency.text!
        }
        
        // ピッカーで選択した機関をテキストフィールドに設定
        dataAgency.text = forAgencyTextField
        
        print("doneAgencyClicked - dataAgency.text: \(dataAgency.text)")
        
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
    
    func lastSelectValueSet(){
        // 打ち上げ期間の設定値を保持
        searchValueSettings.set(dateStartLaunch.text , forKey: "settingStartDate")
        searchValueSettings.set(dateEndLaunch.text , forKey: "settingEndDate")
        // 機関の設定値を保存
        searchValueSettings.set(dataAgency.text, forKey: "settingAgency")
    }
    
    
    //画面遷移時に呼ばれる関数（セグエ経由で遷移先に値を渡す）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        // 検索項目の設定を保存
        lastSelectValueSet()

        let controller = segue.destination as! ResultListViewController
        // 遷移元に検索日付を渡すが、検索URLのパラメタ用に日付の"/"を"-"(ハイフン)に置換える
        controller.searchStartLaunch = dateStartLaunch.text?.replacingOccurrences(of: "/", with: "-") ?? ""
        controller.searchEndLaunch = dateEndLaunch.text?.replacingOccurrences(of: "/", with: "-") ?? ""

        // Agency DataPicker data
        // 検索画面表示用の期間名から、URL検索用の機関名を取得して遷移元に渡す。
//        let forSearchAgency = agenciesDictionary["\(forAgencyTextField)"]
        controller.searchAgency = agenciesDictionary["\(dataAgency.text!)"] ?? ""
        print("dataAgency.text: \(dataAgency.text!)")
        print("agenciesDictionary's Agency: \(agenciesDictionary["\(dataAgency.text!)"])")
        print("SearchRoketViewController - prepare - forAgencyTextField: \(forAgencyTextField)")
//        print("SearchRoketViewController - prepare - forSearchAgency: \(forSearchAgency)")
//        controller.searchAgency = forSearchAgency ?? ""
        
        // 自身のクラス名を設定（遷移先のクラスがどのクラスから遷移されたクラスか判別するため
        print("FavoriteListView - viewDidLoad - Classname: \(className)")
        controller.previousClassName = className

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
        
        // テキストフィールド表示用の値をセットする
        forAgencyTextField = dataSource[row]
        
        // 選択した項目のrow値値を保持（検索画面の前回検索履歴保持）
        // picker表示時に前回選択した項目を表示させるため
        searchValueSettings.set(row, forKey: "selectedRowAgency")

    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        return dataSource[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = dataSource[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
}

