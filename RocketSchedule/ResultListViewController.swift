//
//  ListViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/13.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit

class ResultListViewController: UITableViewController {
    
//    var items = [Launch]()
//    var item:Launch?
    var count: Int = 0
    var jsonLaunches: Launch!
    var isAgencySearch: Bool! = false
    var addedDate:Date!

    
    // Usage of URL "https://launchlibrary.net/1.4/launch?startdate=1907-01-12&enddate=1969-09-20&limit=999999"
    let urlStringOf1: String = "https://launchlibrary.net/1.4/launch"
    let urlStringOf2: String = "&startdate="
    let urlStringOfDefaultStartDate: String = "1907-01-12"
    var urlStringOfSearchStartDate: String = "1907-01-12"
    let urlStringOf3: String = "&enddate="
    let urlStringOfDefaultEndDate: String = "1969-09-20"
    var urlStringOfSearchEndDate: String = "1969-09-20"
    let urlStringOfLimit: String = "&limit=999999"
    let urlStringOfAgency: String = "&agency="
    var urlStringOfAgencyValue: String!
    let urlStringOfVerbose: String = "?mode=verbose"
    
    var url: String!
    
    //search of Rocket
    var searchStartLaunch = ""
    var searchEndLaunch = ""
    var searchAgency = ""
    
    //For Display on PlansView
    var viewRocketPlanData = [StructViewPlans]()
    
    // URL userdefaults
    var searchURL = UserDefaults()
    
    // Class Name: 遷移元のクラス名
    var previousClassName: String = ""
    
    // ロケット名日本語変換クラス
    var rocketEng2Jpn = RocketNameEng2Jpn()
    
    // TimeRelated.swiftを使った処理だが不要のためコメント化
    // Timeintervalの値
//    var timeintervalValue: Double = 0
    
    // 検索結果0件
    var resultZero = false
    
    // Indicator アイコンの定義
    var indicator = UIActivityIndicatorView()
    // インジケーター用のUIViewを宣言
    var indicatorView: UIView!
    // 0件用のUIViewを宣言
    var resultZeroView: UIView!

    
    @IBOutlet weak var buttonSearch: UIBarButtonItem!
    
    @IBAction func searchRocket(_ sender: Any) {
        
        //        let SearchRoketViewController = storyboard?.instantiateViewController(withIdentifier: "SearchRoketViewController") as! SearchRoketViewController
        //
        //        present(SearchRoketViewController, animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "toSearch", sender: nil)
        
    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        print("count:\(count)")
        return count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("ResultListViewController - tableview - start")
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        //TimeZoneはUTCにしなければならない。
        //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
        //日付を返してしまうため。
        let formatterString = DateFormatter()
        formatterString.timeZone = TimeZone(identifier: "UTC")
        formatterString.dateFormat = "yyyy/MM/dd (EEE)"
        formatterString.locale = Locale(identifier: "ja_JP")
        print("ListViewController - tableview - launchDate: \(viewRocketPlanData[indexPath.row].launchDate)")
        cell.labelLaunchDate?.numberOfLines = 0
        cell.labelLaunchDate?.text = "\(formatterString.string(from: viewRocketPlanData[indexPath.row].launchDate))"
        
        
        // Launch Time
        let formatterLaunchTime = DateFormatter()
        formatterLaunchTime.timeZone = TimeZone(identifier: "UTC")
        formatterLaunchTime.locale = Locale(identifier: "ja_JP")
        formatterLaunchTime.dateStyle = .none
        formatterLaunchTime.timeStyle = .medium
        cell.labelLaunchTime?.numberOfLines = 0
        cell.labelLaunchTime?.text = "\(formatterLaunchTime.string(from: viewRocketPlanData[indexPath.row].launchDate))"

        // ロケットを日本語名に変換して表示する
//        cell.labelRocketName?.text = "\(self.jsonLaunches.launches[indexPath.row].name)"
        cell.labelRocketName?.numberOfLines = 0
        // フォントサイズの自動調節
        cell.labelRocketName?.adjustsFontSizeToFitWidth = true
        cell.labelRocketName?.text =
            rocketEng2Jpn.checkStringSpecifyRocketName(name: self.jsonLaunches.launches[indexPath.row].name)

        print("ResultListViewController - tableview - end")

//        let indexPathForTop = IndexPath(row: 0, section: 0)
//        self.tableView.scrollToRow(at: indexPathForTop, at: .top, animated: true)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
    
    func activityIndicator() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        // インジケーターアイコンの丸み表現
        indicator.layer.cornerRadius = 8
        indicator.style = UIActivityIndicatorView.Style.white
//        indicator.center = self.indicatorView.center
        indicator.center = CGPoint.init(x: self.indicatorView.bounds.width / 2, y: self.indicatorView.bounds.height / 3)
        self.view.addSubview(indicator)
    }
    
    // インジケーター用のUIViewを生成
    func enableIndicatorView() {

        // init Boundsで全画面にviewを表示
        self.indicatorView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        //        let bgColor = UIColor.gray
        let bgColor = UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        self.indicatorView.backgroundColor = bgColor
        self.indicatorView.isUserInteractionEnabled = true
        self.view.addSubview(indicatorView)

        // 検索実行時のみこのviewを表示するため、それ以外は非表示にする。
        self.indicatorView.isHidden = true
    }

    // 0件用のUIViewを生成
    func enableResultZeroView() {
        
        // init Boundsで全画面にviewを表示
        self.resultZeroView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        let bgColor = UIColor.init(red: 255/255, green: 38/255, blue: 38/255, alpha: 1)
        self.resultZeroView.backgroundColor = bgColor
        self.resultZeroView.isUserInteractionEnabled = true
        self.view.addSubview(resultZeroView)
        
        // 検索0件の時だけこのviewを表示するため、それ以外は非表示にする。
        self.resultZeroView.isHidden = true
    }
    var zeroMessage = UILabel()
    
    // 0件用のUIViewを表示
    func enableIndicatorViewZero() {
        
        // 0件メッセージ
        self.zeroMessage = UILabel.init(frame: CGRect.init(x: 20, y: 20, width: 200, height: 10))
        self.zeroMessage.text = "該当なし"
        self.zeroMessage.textColor = UIColor.white
        self.zeroMessage.font = UIFont.init(name: "Futura", size: 20)
        self.view.addSubview(self.zeroMessage)

    }

    
    override func viewDidLoad() {
        
        print("ResultListViewController - viewDidLoad - Start")
        
        super.viewDidLoad()
        
        // viewDidAppearのswitch処理用
        // 初回起動時はインジケーター表示・JSONロードのみ処理を行う
        previousClassName = "viewDidLoad"
        
        // インジケーター用のviewを生成
        enableIndicatorView()
        // 0件用のviewを生成
        enableResultZeroView()
        // 0件メッセージの表示
        enableIndicatorViewZero()

        // インジケーターアイコンの生成
        activityIndicator()
        
        // cell borderline size
        tableView.separatorInset =
            UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);
        
        // TimeRelated.swiftを使った処理だが不要のためコメント化
//        // GMTからTimeinterval用の値を取得
//        let timeRelated = TimeRelated()
//        let gmtValue = timeRelated.getGmtValue()
//        print("Abbreviation Value: \(gmtValue)")
//        timeintervalValue = timeRelated.getTimeintervalValue(gmtValue: gmtValue)

        print("ResultListViewController - viewDidLoad - End")

    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        print("ResultListViewController - viewDidAppear - Start")
        print("In viewDidAppear - searchAgency: \(searchAgency)")
        print("searchStartLaunch: \(searchStartLaunch)")
        print("searchEndLaunch: \(searchEndLaunch)")
        
        // 0件用のUIを初期化（非表示）
        self.zeroMessage.isHidden = true
        self.resultZeroView.isHidden = true

        // インジケーターの表示・JSONロードの判定
        // 呼び出し元によって、以下switch-caseの処理を実行する。
        let constantClassName = StructClassName()
        switch previousClassName {
        // 初回起動時
        case constantClassName.functionName_01:
            print("IN - case constantClassName.functionName_01")
            
            // インジケーター用のUIViewを表示
//            enableIndicatorView()
            self.indicatorView.isHidden = false
            
            // Indicatorのスタート
            activityIndicator()
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.black
            
            // 検索中は検索ボタンを無効化
            buttonSearch.isEnabled = false
            
            // URLを取得
            if searchURL.string(forKey: "settingURL") != nil{
                print("searchURL Userdefault: \(searchURL.string(forKey: "settingURL"))")
                url = searchURL.string(forKey: "settingURL")
            }else{
                // 前回検索なし・初回起動時はアプリ起動日から起動日ー１週間前までの
                // URLを生成処理を実装する
                // do something
                
                // 暫定対応
                url = "https://launchlibrary.net/1.4/launch?mode=verbose&startdate=2017-07-23&enddate=2018-09-01&agency=JAXA&limit=999999"
                
            }
            // URL検索
            launchJsonDownload()
            
            // previousClassName初期化
            previousClassName = ""
            
            print("OUT - case constantClassName.functionName_01")
        // 検索画面から検索実行
        case constantClassName.className_03:
            print("IN - case constantClassName.className_03")
            
            // インジケーター用のViewを最前面に表示
            self.view.bringSubviewToFront(self.indicatorView)
            // インジケーター用のUIViewを表示
//            enableIndicatorView()
            self.indicatorView.isHidden = false

            // Indicatorのスタート
            activityIndicator()
            indicator.startAnimating()
            indicator.backgroundColor = UIColor.black
            
            if !resultZero {
                // 途中までスクロールしていた場合は、リストの先頭に移動する
                let indexPathForTop = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPathForTop, at: .top, animated: true)
            }
            resultZero = false
            
            // 検索中は検索ボタンを無効化
            buttonSearch.isEnabled = false
            
            // 検索URLの生成
            if searchStartLaunch == "" {
                print("searchStartLaunch : \(searchStartLaunch)")
                // 初回起動時はtrueになる
                //            isDefaultSearch = true
                urlStringOfSearchStartDate = urlStringOfDefaultStartDate
            } else {
                urlStringOfSearchStartDate = searchStartLaunch
            }
            
            if searchEndLaunch == "" {
                print("searchEndLaunch : \(searchEndLaunch)")
                urlStringOfSearchEndDate = urlStringOfDefaultEndDate
            } else {
                urlStringOfSearchEndDate = searchEndLaunch
            }
            // 機関が選択された場合は、URLに機関項目を設定する
            if searchAgency == ""{
                isAgencySearch = false
            }else{
                if searchAgency != "すべて"{
                    urlStringOfAgencyValue = searchAgency
                    print("ResultListViewController - viewDidAppear - urlStringOfAgencyValue: \(urlStringOfAgencyValue)")
                    
                    isAgencySearch = true
                }else{
                    isAgencySearch = false
                }
            }
            // 検索画面において機関項目を選択した場合は、機関項目を付加したURLを発行する
            if isAgencySearch{
                url = urlStringOf1 + urlStringOfVerbose + urlStringOf2 + urlStringOfSearchStartDate + urlStringOf3 + urlStringOfSearchEndDate + urlStringOfAgency + urlStringOfAgencyValue + urlStringOfLimit
            } else {
                url = urlStringOf1 + urlStringOfVerbose + urlStringOf2 + urlStringOfSearchStartDate + urlStringOf3 + urlStringOfSearchEndDate + urlStringOfLimit
            }
            
            // URLを保持
            searchURL.set(url , forKey: "settingURL")
            // URL検索
            launchJsonDownload()
            
            // previousClassName初期化
            previousClassName = ""
            
            print("OUT - case constantClassName.className_03")
        // 遷移元が初回起動時・検索実行時以外の場合
        default:
            print("IN - default")
            // previousClassName初期化
            previousClassName = ""
            
            if resultZero {
                // インジケーター用のViewを最前面に表示
//                self.view.bringSubviewToFront(self.resultZeroView)
                self.resultZeroView.isHidden = false
                self.zeroMessage.isHidden = false
            }
            print("OUT - default")
        }

        print("ResultListViewController - viewDidAppear - RequestURL: \(url)")
        print("ResultListViewController - viewDidAppear - End")
    }
    
    
    func launchJsonDownload(){
        
        if let url = URL(
            //            string: "https://launchlibrary.net/1.4/launch?startdate=1907-01-12&enddate=1969-09-20&limit=999999"){
            string: "\(url!)"){
            
            print("ResultListViewController - launchJsonDownload - URL: \(url)")
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {
                    print(response)
                    

                    let testdata = String(data: data, encoding: .utf8)!
//                    print("data:\(testdata)")
                    
                    if testdata.contains("None found"){
                        
                        print("testdata: None Found")
                        
                        self.count = 0
                        
                        // 非同期処理完了後の処理（0件)
                        DispatchQueue.main.async {
                            
                            print("DispatchQueue.main.async - IN - count=0")
                            
                            if let httpResponse = response as? HTTPURLResponse {
                                print("status code: \(httpResponse.statusCode)")
                            }
                            
                            // テーブル情報のリロード
                            self.tableView.reloadData()
                            
                            // 0件用viewの表示
                            self.resultZeroView.isHidden = false
                            // インジケーターviewの非表示
                            self.indicatorView.isHidden = true

                            // インジケーター用のViewを最前面に表示
//                            self.view.bringSubviewToFront(self.indicatorZeroView)

                            // インジケーターアイコンを非表示
                            self.indicator.stopAnimating()
                            
                            // 0件メッセージの表示
//                            self.enableIndicatorViewZero()
                            self.zeroMessage.isHidden = false
                            
                            // 検索後は検索ボタンを有効化
                            self.buttonSearch.isEnabled = true
                            
                            // 結果0件
                            self.resultZero = true

                            print("DispatchQueue.main.async - OUT - count=0")
                            
                        }
                        
                    } else {
                        
                        let json = try! JSONDecoder().decode(Launch.self, from: data)
                        
                        self.count = json.count
                        
                        self.jsonLaunches = json

//                        print("ResultListViewController - JSON Data: \(json)")

                        // Initialize to Struct
                        self.viewRocketPlanData = [StructViewPlans]()
                        
                        for launch in json.launches {
                            
                            // calendarを日付文字列だ使ってるcalendarに設定
                            let formatterString = DateFormatter()
                            //TimeZoneはUTCにしなければならない。
                            //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
                            //日付を返してしまうため。
                            formatterString.timeZone = TimeZone(identifier: "UTC")
//                            formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            formatterString.dateFormat = "MMMM dd, yyyy HH:mm:ss z"
                            let jsonDate = launch.windowstart
                            //                        print ("jsonDate:\(jsonDate)")
                            
                            if let dateString = formatterString.date(from: jsonDate){
//                                print("dateString:\(String(describing: dateString))")
                                
                                formatterString.locale = Locale(identifier: "ja_JP")
                                formatterString.dateStyle = .full
                                formatterString.timeStyle = .medium
                                
                                // システム設定しているタイムゾーンを元にUTCから発射日時を算出する
                                // TimeRelated.swiftを使った処理だが不要のためコメント化
//                                print("timeintervalValue: \(self.timeintervalValue)")
//                                self.addedDate = Date(timeInterval: self.timeintervalValue, since: dateString)
                                self.addedDate = Date(timeInterval: Double(Calendar.current.timeZone.secondsFromGMT()), since: dateString)

                                //LaunchDate,RocketName added to struct for display on PlansView
                                self.viewRocketPlanData.append(StructViewPlans(
                                    launchData: self.addedDate,
                                    rocketName: launch.name))
//                                print("name:\(launch.name)")
                            }
                        }
                        
                        // 非同期処理完了後の処理（JSONダウンロード完了後）
                        DispatchQueue.main.async {
                            
                            print("DispatchQueue.main.async - IN")
                            
                            if let httpResponse = response as? HTTPURLResponse {
                                print("ステータスコード: \(httpResponse.statusCode)")
                            }
                            
//                            // 0件メッセージの非表示
//                            self.zeroMessage.isHidden = true
                            
                            // テーブル情報のリロード
                            self.tableView.reloadData()
                            
                            // インジケーターアイコンを非表示
                            self.indicator.stopAnimating()
                            
                            // インジケーター用のUIViewを非表示
                            self.indicatorView.isHidden = true
                            
                            // 検索後は検索ボタンを有効化
                            self.buttonSearch.isEnabled = true
                            
                            print("DispatchQueue.main.async - OUT")

                        }
                    }
                }
            })
            
            print("task.resumeの手前 - self.count: \(self.count)")
            
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let launch = self.jsonLaunches.launches[indexPath.row]
            let controller = segue.destination as! DetailViewController
            controller.id = launch.id
            controller.name = launch.name
            controller.rocketImageURL = launch.rocket.imageURL

            // 詳細画面にDate型の日付を渡す
            // 詳細画面での日付・時刻分け表示に都合がよいため
            controller.launchDate = viewRocketPlanData[indexPath.row].launchDate
            //            controller.windowStart = launch.windowstart
            controller.windowEnd = launch.windowend
            
            //            controller.videoURL = launch.vidURLs?[0]
            controller.videoURL = launch.vidURLs
//            if let vidURLs = launch.vidURLs{
//                controller.videoURL = vidURLs
//            }

            // Agency name send to DetailView
            if launch.location.pads[0].agencies != nil{
                if launch.location.pads[0].agencies!.count != 0{
                    if let agency = launch.location.pads[0].agencies{
                        print("ListViewController - prepare - agency : \(agency[0].abbrev)")
                        controller.agency = agency[0].abbrev
                    }
                }else{
                    controller.agency = "機関名なし"
                }
            }else{
                controller.agency = "機関名なし"
            }

        }
        
    }
    
}


