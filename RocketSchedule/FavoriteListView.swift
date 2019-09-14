//
//  FavoriteListView.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/06/28.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class FavoriteListView: UITableViewController {
    
    // 「今回は使用していないのでコメント化」リストに表示される○からマルチ選択した場合の処理
    // 関連するプログラム：StateSelectFavorite.swift
//    private var state: RocketFavoriteSelectState = FavoriteSelect()

//    @IBAction func buttonSelect(_ sender: UIButton) {
//
//        // ボタンタップ時にお気に入りの登録、または未登録によって処理を変更する
//        self.state.buttonTapped(favoriteListView: self)
//
//    }
//    @IBOutlet weak var buttonSelectOutlet: UIButton!
    
    // Self Class Name
    var className: String {
        return String(describing: type(of: self)) // ClassName
    }
    
    var count: Int = 0
    var jsonLaunches: Launch!
//    var favoriteLaunches = StructRealmFavoriteData()
    var arrayFavoriteLaunches = [StructRealmFavoriteData]()
    var isAgencySearch: Bool! = false
    
    
    // Usage of URL "https://launchlibrary.net/1.4/launch?startdate=1907-01-12&enddate=1969-09-20&limit=999999"
    let urlStringOf1: String = "https://launchlibrary.net/1.4/launch"
    let urlStringOf2: String = "?startdate="
    let urlStringOfDefaultStartDate: String = "1907-01-12"
    var urlStringOfSearchStartDate: String = "1907-01-12"
    let urlStringOf3: String = "&enddate="
    let urlStringOfDefaultEndDate: String = "1969-09-20"
    var urlStringOfSearchEndDate: String = "1969-09-20"
    let urlStringOfLimit: String = "&limit=999999"
    let urlStringOfAgency: String = "&agency="
    var urlStringOfAgencyValue: String!
    let urlStringOfVerbose: String = "&mode=verbose"
    
    var url: String!
    
    //search of Rocket
    var searchStartLaunch: String?
    var searchEndLaunch: String?
    var searchAgency: String?
    
    // ロケット名日本語変換クラス
    var rocketEng2Jpn = RocketNameEng2Jpn()
    
    // お気に入り登録0件用のUIViewを宣言
    var resultZeroView: UIView!

    // お気に入り0件用メッセージ
    var zeroMessage = UILabel()
    var zeroMessage_2 = UILabel()

    // お気に入り0件用画像
    var zeroImage = UIImage()
    var zeroImageView = UIImageView()

    // Realm
//    let realm = try! Realm()
    
    // Select cell swipe to the left
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell

        if editingStyle == .delete {
            
//            print("FavoriteListView - tableView - cell.labelRocketId: \(cell.labelRocketId?.text)")
            
//            let targetId = Int(cell.labelRocketId.text ?? "0")
            let targetId = Int(arrayFavoriteLaunches[indexPath.row].id)

            print("FavoriteListView - tableView - targetId: \(targetId)")
            
            // Call Data Delete Func
            self.removeFavorite(id: targetId)
            
            // Specify Cell Remove from Datasource
            self.arrayFavoriteLaunches.remove(at: indexPath.row)
            
            // Delete Cell
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Favorit View Reload
//            self.tableView.reloadData()

            
        }
        
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        print("count:\(arrayFavoriteLaunches.count)")
        return arrayFavoriteLaunches.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
//
//        // Launch Date add Local Date
//        let formatterString = DateFormatter()
//        //TimeZoneはUTCにしなければならない。
//        //理由は、UTCに指定していないと、
//        //DateFormatter.date関数はcurrentのゾーンで
//        //日付を返してしまうため。
//        formatterString.timeZone = TimeZone(identifier: "UTC")
//        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
////        print ("FavoriteListView - tableView - arrayFavoriteLaunchesWindowStart:\(self.arrayFavoriteLaunches[indexPath.row].windowStart)")
//        let jsonDate = self.arrayFavoriteLaunches[indexPath.row].windowStart
//        print ("jsonDate:\(jsonDate)")
//
//        if let dateString = formatterString.date(from: jsonDate){
//            print("dateString:\(String(describing: dateString))")
//
//            formatterString.locale = Locale(identifier: "ja_JP")
//            //            formatterString.locale = Locale.current
//            formatterString.dateStyle = .full
//            formatterString.timeStyle = .medium
//
//            //UTC + 9(Japan)
//            let addedDate = Date(timeInterval: 60*60*9*1, since: dateString)
//            print("addedDate:\(addedDate)")
//
//            print("formatterString:\(formatterString.string(from: addedDate)))")
//
//            // Launch Date For Display on Favorit View
//            formatterString.dateFormat = "yyyy/MM/dd (EEE)"
//            cell.labelLaunchDate?.numberOfLines = 0
//            cell.labelLaunchDate?.text = "\(formatterString.string(from: addedDate))"
//
//            // Launch Date For Display on Favorit View
//            formatterString.dateFormat = "HH:mm:ss"
//            cell.labelLaunchTime?.numberOfLines = 0
//            cell.labelLaunchTime?.text = "\(formatterString.string(from: addedDate))"
//
//        }else{
//            print("dateString is nil")
//        }
//
//        cell.labelRocketName?.numberOfLines = 0
//        cell.labelRocketName?.text = "\(self.arrayFavoriteLaunches[indexPath.row].rocketName)"
        
        
        print("FavoriteListView - tableview - start")
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        //TimeZoneはUTCにしなければならない。
        //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
        //日付を返してしまうため。
        let formatterString = DateFormatter()
        formatterString.timeZone = TimeZone(identifier: "UTC")
        formatterString.dateFormat = "yyyy/MM/dd (EEE)"
        formatterString.locale = Locale(identifier: "ja_JP")
        print("FavoriteListView - tableview - launchDate: \(arrayFavoriteLaunches[indexPath.row].launchDate)")
        cell.labelLaunchDate?.numberOfLines = 0
        cell.labelLaunchDate?.text = "\(formatterString.string(from: arrayFavoriteLaunches[indexPath.row].launchDate))"
        
        
        // Launch Time
        let formatterLaunchTime = DateFormatter()
        formatterLaunchTime.timeZone = TimeZone(identifier: "UTC")
        formatterLaunchTime.locale = Locale(identifier: "ja_JP")
        formatterLaunchTime.dateStyle = .none
        formatterLaunchTime.timeStyle = .medium
        cell.labelLaunchTime?.numberOfLines = 0
        cell.labelLaunchTime?.text = "\(formatterLaunchTime.string(from: arrayFavoriteLaunches[indexPath.row].launchDate))"
        
        // ロケットを日本語名に変換して表示する
//        cell.labelRocketName?.text = "\(arrayFavoriteLaunches[indexPath.row].rocketName)"
        cell.labelRocketName?.numberOfLines = 0
        cell.labelRocketName?.adjustsFontSizeToFitWidth = true
        cell.labelRocketName?.text =
            rocketEng2Jpn.checkStringSpecifyRocketName(name: arrayFavoriteLaunches[indexPath.row].rocketName)
        
        
        // ロケット画像の表示
        print("tableView - Before ImageURL: \(self.arrayFavoriteLaunches[indexPath.row].rocketImageURL)")
        let replacedImageURL = self.arrayFavoriteLaunches[indexPath.row].rocketImageURL.replacingOccurrences(of: "_1920.png", with: "_480.png")
        print("tableView - After ImageURL: \(replacedImageURL)")
        cell.rocketImageSetCell(imageUrl: replacedImageURL)
        
        
        print("FavoriteListView - tableview - end")
        

        return cell
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // comment reason: Launch Data get from Realm
//        launchJsonDownload()
        
        // バックボタンのタイトルを設定
        // 遷移先のバックボタンにタイトルを設定する場合は、title: に文字を設定する。
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // cell borderline size
        tableView.separatorInset =
            UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);

        // お気に入り0件用のviewを生成
        enableResultZeroView()
        // 0件メッセージをを生成
        enableMessageViewZero()
        // 0件用画像の生成
        enableImageForZero()
        
        // Read Realm Data
//        launchDataLoad()
        if launchDataLoad() == 0{
            resultZeroView.isHidden = false
            zeroMessage.isHidden = false
            zeroMessage_2.isHidden = false
            zeroImageView.isHidden = false
        }else{
            resultZeroView.isHidden = true
            zeroMessage.isHidden = true
            zeroMessage_2.isHidden = true
            zeroImageView.isHidden = true
        }

    }

    // お気に入り0件用のUIViewを生成
    func enableResultZeroView() {
        
        // init Boundsで全画面にviewを表示
        self.resultZeroView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        let bgColor = UIColor.init(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        self.resultZeroView.backgroundColor = bgColor
        self.resultZeroView.isUserInteractionEnabled = true
        self.view.addSubview(resultZeroView)
        
        // 検索0件の時だけこのviewを表示するため、それ以外は非表示にする。
        self.resultZeroView.isHidden = true
    }
    
    // 0件用のメッセージを表示
    func enableMessageViewZero() {
        
        // 0件メッセージ
        self.zeroMessage = UILabel.init(frame: CGRect.init(x: 0,
                                                           y: 40,
                                                           width: view.frame.size.width,
                                                           height: 10))
        self.zeroMessage.textAlignment = NSTextAlignment.center
        self.zeroMessage.text = "お気に入りのロケット情報を登録しましょう"
        self.zeroMessage.textColor = UIColor.white
        self.zeroMessage.font = UIFont.init(name: "Futura-Bold", size: 15)
        self.view.addSubview(self.zeroMessage)
        
        // 0件メッセージ
        self.zeroMessage_2 =
            UILabel.init(frame: CGRect.init(x: 0,
                                            y: 375,
                                            width: view.frame.size.width,
                                            height: 10)
                        )
        self.zeroMessage_2.textAlignment = NSTextAlignment.center
        self.zeroMessage_2.text = "打ち上げ結果画面のスターをタップ"
        self.zeroMessage_2.textColor = UIColor.white
        self.zeroMessage_2.font = UIFont.init(name: "Futura-Bold", size: 15)
        self.view.addSubview(self.zeroMessage_2)
    }

    // 0件用のメッセージを表示
    func enableImageForZero() {
        
        zeroImage = UIImage(named: "01_ResultView")!
        zeroImageView = UIImageView(image: zeroImage)

        // スクリーンの縦横サイズを取得
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        
        // 画像の縦横サイズを取得
        let imgWidth:CGFloat = zeroImage.size.width
        let imgHeight:CGFloat = zeroImage.size.height
        
        // 画像サイズをスクリーン幅に合わせる
        let scale:CGFloat = screenWidth / imgWidth
        let rect:CGRect =
            CGRect(x:0, y:0, width:imgWidth * scale, height:imgHeight * scale)
        
        // ImageView frame をCGRectで作った矩形に合わせる
        zeroImageView.frame = rect
        
        // 画像の中心を画面の中心に設定
        zeroImageView.center = CGPoint(x:screenWidth/2, y:screenHeight/4)
        
        // UIImageViewのインスタンスをビューに追加
        self.view.addSubview(zeroImageView)
        
    }

    //リフレッシュ処理
    @objc func refresh(sender: UIRefreshControl) {
        print("In refresh Start")

        // comment reason: Launch Data get from Realm
//        //Json再取得
//        launchJsonDownload()
        
        sender.endRefreshing()
        
        print("In refresh End")
    }
    

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        // Read Realm Data
//        launchDataLoad()
        if launchDataLoad() == 0{
            resultZeroView.isHidden = false
            zeroMessage.isHidden = false
            zeroMessage_2.isHidden = false
            zeroImageView.isHidden = false
        }else{
            resultZeroView.isHidden = true
            zeroMessage.isHidden = true
            zeroMessage_2.isHidden = true
            zeroImageView.isHidden = true
        }
        
        tableView.reloadData()
        
    }

    // 「今回は使用していないのでコメント化」リストに表示される○からマルチ選択した場合の処理
//    // Set to state
//    func setState(state: RocketFavoriteSelectState){
//        self.state = state
//    }
//
//    func setToSelectMode(){
//
//        print("FavoriteListView - setToSelectMode - IN")
//
//        // multi
////        tableView.isEditing = true
//        setEditing(true, animated: true)
//        tableView.allowsMultipleSelectionDuringEditing = true
//
//        print("FavoriteListView - setToSelectMode - OUT")
//    }
//
//    func setToNormalMode(){
//
//        print("FavoriteListView - setToNormalMode - IN")
//
//        // multi
////        tableView.isEditing = false
//        setEditing(false, animated: true)
//        tableView.allowsMultipleSelectionDuringEditing = false
//
//        print("FavoriteListView - setToNormalMode - OUT")
//    }
    
    
    func launchDataLoad() -> Int {
        
        // Realm
        let realm = try! Realm()
        
        // Initialize to Arrya Struct
        arrayFavoriteLaunches = [StructRealmFavoriteData]()

        // Get From Realm
//        let getAllDataRealm = realm.objects(FavoriteObject.self)
        let getAllDataRealm = realm.objects(FavoriteObject.self).sorted(byKeyPath: "addedDate", ascending: true)
        
        print("getAllDataRealm.count:\(getAllDataRealm.count)")
        
        if getAllDataRealm.count == 0{
            return getAllDataRealm.count
        }

        // RealmData input to Array Struct
        for data in getAllDataRealm{
            
            print("FavoriteListView - launchDataLoad - for - data: \(data.windowStart)")
            
            var videoUrlArray: [String] = []
            for videoUrlData in data.videoUrls{
                videoUrlArray.append(videoUrlData.urlList)
            }
            
            arrayFavoriteLaunches.append(
                StructRealmFavoriteData(
                    id:             data.id,
                    rocketName:     data.rocketName,
                    windowsStart:   data.windowStart,
                    windowEnd:      data.windowEnd,
                    videoURLs:      videoUrlArray,
                    launchDate:     data.launchDate,
                    agency:         data.agency,
                    rocketImageURL: data.rocketImageURL,
                    rocketImageUrlForCell:  data.rocketImageUrlForCell
                )
            )
            
        }
        
        print("FavoriteListView - launchDataLoad - arrayFavoriteLaunches.count: \(arrayFavoriteLaunches.count)")
//        print("FavoriteListView - launchDataLoad - arrayFavoriteLaunches[0].id: \(arrayFavoriteLaunches[0].id)")

        return arrayFavoriteLaunches.count
    }
    
    func launchJsonDownload(){
        
        if let url = URL(
                        string: "https://launchlibrary.net/1.4/launch?startdate=1907-01-12&enddate=1969-09-20&limit=999999"){
//            string: "\(url!)"){

            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {
                    print(response)

                    let testdata = String(data: data, encoding: .utf8)!
                    print("data:\(testdata)")

                    if testdata.contains("None found"){

                        self.count = 0

                    } else {

                        let json = try! JSONDecoder().decode(Launch.self, from: data)

                        self.count = json.count

                        self.jsonLaunches = json

                        for launch in json.launches {
                            print("name:\(launch.name)")
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

    
    // Rocket remove favorite
    func removeFavorite(id: Int){
        
        print("FavoriteListView - IN - removeFavorite")
        
        // do something
        let realm = try! Realm()
        print("FavoriteListView - removeFavorite - queryId:  \(id)")
        let filterRealm = realm.objects(FavoriteObject.self).filter("id = \(id)")
        
        // Data Delete that swiped cell
        try! realm.write {
            realm.delete(filterRealm)
        }
        
        print("FavoriteListView - OUT - removeFavorite")
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let launch = self.arrayFavoriteLaunches[indexPath.row]
            let controller = segue.destination as! DetailViewController
            controller.id = launch.id
            controller.name = launch.rocketName
            controller.windowStart = launch.windowStart
            controller.videoURL = launch.videoURLs
            controller.agency = launch.agency
            // 詳細画面にDate型の日付を渡す
            // 詳細画面での日付・時刻分け表示に都合がよいため
            controller.launchDate = launch.launchDate
            
            controller.rocketImageURL = launch.rocketImageURL
            
            // 自身のクラス名を設定（遷移先のクラスがどのクラスから遷移されたクラスか判別するため
            print("FavoriteListView - viewDidLoad - Classname: \(className)")
            controller.previousClassName = className

        }
    }
}


