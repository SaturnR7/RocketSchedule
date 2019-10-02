//
//  DetailViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/30.
//  Copyright © 2019 zilch. All rights reserved.
//
//  Launch Result Detail View (From Launch Result View)

import Foundation
import UIKit
import RealmSwift

class DetailViewController : UIViewController {
    
    private var state: RocketFavoriteState = RocketNotAddedAsFavorite()
    
    @IBOutlet weak var detailRocketName: UILabel!
    
    @IBOutlet weak var detailRocketNameEng: UILabel!
    
    @IBOutlet weak var labelLaunchDate: UILabel!
    
    @IBOutlet weak var labelLaunchTime: UILabel!
    
    @IBOutlet weak var labelTimezone: UILabel!
    
    @IBOutlet weak var buttonFavorite: UIButton!
    
    @IBAction func buttonFavoriteTapped() {
        // ボタンタップ時にお気に入りの登録、または未登録によって処理を変更する
        self.state.buttonFavoriteTapped(detailViewController: self)
        
        // ロケット情報のお気に入り登録状況によってお気に入りアイコンを変更する
        // 登録あり：★
        // 登録なし：☆
        if isFavoriteDataExist(){
            self.buttonFavorite.setImage(UIImage.init(named: "Icon_Tab_03_favorite"), for: .normal)
        }else{
            self.buttonFavorite.setImage(UIImage.init(named: "Icon_Tab_03_favorite_off"), for: .normal)
        }

    }
    
    @IBOutlet weak var imageRocket: UIImageView!
    
    @IBOutlet weak var labelLiveStream: UILabel!
    
    @IBOutlet weak var labelAgency: UILabel!
    
    @IBAction func tapLabelAgency(_ sender: Any) {
        
        if self.agencyURL != ""{
            UIApplication.shared.open(URL(string: self.agencyURL )! as URL,options: [:],completionHandler: nil)
        }

    }
    
    
    var id: Int = 0
    var name: String = ""
    var launchDate: Date!
    var windowStart: String = ""
    var windowEnd: String = ""
//    var videoURL: String!
    var videoURL: [String]?
    var notifySwitch: Bool!
    var agency: String = ""
    var agencyFormalName: String = ""
    var agencyURL: String = ""
    var missionName: String = ""

    // Class Name: 遷移元のクラス名
    var previousClassName: String = ""

//    var notificationCondition:Bool = false
    
    let notificationCenter = NotificationCenter.default
    
    // UserDefauls for Favorite
    // Comment. reason: Data using RealmDB
//    public let defaultsForFavorite = UserDefaults.standard
    
    var rocketImageURL: String?
    var rocketImageUrlForCell: String = ""
    
    // ロケット名日本語変換クラス
    var rocketEng2Jpn = RocketNameEng2Jpn()

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("DetailViewController - viewDidLoad Start")
        
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        self.navigationController?.navigationBar.tintColor = .white
        // バックボタンのタイトルを設定
        // 遷移先のバックボタンにタイトルを設定する場合は、title: に文字を設定する。
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // ロケット情報のお気に入り登録状況によってお気に入りアイコンを変更する
        // 登録あり：★
        // 登録なし：☆
        if isFavoriteDataExist(){
            self.buttonFavorite.setImage(UIImage.init(named: "Icon_Tab_03_favorite"), for: .normal)
        }else{
            self.buttonFavorite.setImage(UIImage.init(named: "Icon_Tab_03_favorite_off"), for: .normal)
        }

        // Rocket Name JPN
        detailRocketName.text = rocketEng2Jpn.checkStringSpecifyRocketName(name: self.name)
        
        // Rocket Name ENG
        detailRocketNameEng.adjustsFontSizeToFitWidth = true
        detailRocketNameEng.text = self.name
        
        // Launch Date
        let formatterLaunchDate = DateFormatter()
        formatterLaunchDate.timeZone = TimeZone(identifier: "UTC")
        formatterLaunchDate.locale = Locale(identifier: "ja_JP")
        formatterLaunchDate.dateStyle = .full
        formatterLaunchDate.timeStyle = .none
        labelLaunchDate.text? = "\(formatterLaunchDate.string(from: self.launchDate))"
//        labelLaunchDate.text = self.windowStart

        // Launch Time
        let formatterLaunchTime = DateFormatter()
        formatterLaunchTime.timeZone = TimeZone(identifier: "UTC")
        formatterLaunchTime.locale = Locale(identifier: "ja_JP")
        formatterLaunchTime.dateStyle = .none
        formatterLaunchTime.timeStyle = .medium
        labelLaunchTime.text? = "\(formatterLaunchTime.string(from: self.launchDate))"
        
        // ユーザーのタイムゾーンの略語を設定する
        let getTimezoneAbb = DicTimeZone()
        labelTimezone.text? =
        "(\( getTimezoneAbb.getTimezoneAbbreviation(key: TimeZone.current.identifier)))"
//        labelTimezone.text? = "(\(TimeZone.current.identifier))"

        // ロケットの動画をアイコンにセットする処理
        // vidURLs配列は動画URLが登録されている
        // 動画URLが0件の場合は、動画アイコンを表示しない
        if self.videoURL?.count != 0{
            
            let urlsCount = self.videoURL!.count
            
            // Title set to VideoButton
            videoButtonSetTitle(videoCount: urlsCount)
            
            // VideoButton controll by URL's count
            videoButtonControll(videoCount: urlsCount)
            
        }else{
            videoLinkOutlet.setTitle("なし", for: .normal)
            videoLinkOutlet.isEnabled = false
            videoLinkOutlet2.isHidden = true
            videoLinkOutlet3.isHidden = true
        }
        
        // 画面起動時にロケットのIDがRealmに存在していれば、
        // stateにRocketAddedAsFavoriteクラスを入れる必要がある。
        checkExistFavorite()
        
        
        // 機関名をラベル表示用にするため、Dictionaryから日本語表記名を取得する
        let dicAgencies = DicAgencies()
        let agency = dicAgencies.getAgencyOfJapanese(key: self.agency)
        print("DetailRocketViewController - viewDidLoad - agency: \(agency)")
        labelAgency.text = agency

        
        // Get Rocket Image
        if let rocketImageURL = rocketImageURL{
            loadImage(urlString: rocketImageURL)
        }
        
        // お気に入りボタンの表示・非表示判定
        // 遷移元の画面によりお気に入りボタンを制御する
        // 表示する　：ResultListViewController
        // 表示しない：FavoriteListView
        let constantClassName = StructClassName()
        print("previousClassName: \(previousClassName)")
        switch previousClassName {
        case constantClassName.className_02:
            buttonFavorite.isHidden = true
        default:
            buttonFavorite.isHidden = false
        }

        print("DetailViewController - viewDidLoad End")

    }
    
    // Title set to VideoButton
    func videoButtonSetTitle(videoCount: Int){
        
        for target in 1...videoCount {
            print("Video Count: \(target)")
            switch target{
            case 1:
//                    videoLinkOutlet.setTitle("📹", for: .normal)
                    videoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            case 2:
//                    videoLinkOutlet.setTitle("📹", for: .normal)
//                    videoLinkOutlet2.setTitle("📹", for: .normal)
                    videoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet2.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            case 3:
//                    videoLinkOutlet.setTitle("📹", for: .normal)
//                    videoLinkOutlet2.setTitle("📹", for: .normal)
//                    videoLinkOutlet3.setTitle("📹", for: .normal)
                    videoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet2.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet3.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            case 4:
                    videoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet2.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet3.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet4.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            case 5:
                    videoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet2.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet3.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet4.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet5.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            case 6:
                    videoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet2.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet3.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet4.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet5.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet6.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            case 7:
                    videoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet2.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet3.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet4.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet5.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet6.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet7.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            case 8:
                    videoLinkOutlet.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet2.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet3.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet4.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet5.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet6.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet7.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)
                    videoLinkOutlet8.setImage(UIImage.init(named: "Icon_View_02_video"), for: .normal)

            default:
                print("default")
            }
        }
    }
    
    // Hidden set to VideoLink
    func videoButtonControll(videoCount: Int){
        
        // videoCount -> 再生できる動画の本数
        switch videoCount {
        case 1: videoLinkOutlet.isHidden = false
                videoLinkOutlet2.isHidden = true
                videoLinkOutlet3.isHidden = true

        case 2: videoLinkOutlet.isHidden = false
                videoLinkOutlet2.isHidden = false
                videoLinkOutlet3.isHidden = true

        case 3: videoLinkOutlet.isHidden = false
                videoLinkOutlet2.isHidden = false
                videoLinkOutlet3.isHidden = false
            
        default:
            print("switch default")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 画面起動時にロケットのIDがRealmに存在していれば、
        // stateにRocketAddedAsFavoriteクラスを入れる必要がある。
//        checkExistFavorite()
        
        // 当画面に遷移した時、
        // 当画面のロケット情報がお気に入り画面のお気に入り情報に
        // 登録しているかRealmで存在チェックする
        // 存在している場合：stateモードを削除モード（RocketAddedAsFavorite）にする
        // 存在していない場合：stateモードを追加モード（RocketNotAddedAsFavorite）にする
        if !isFavoriteDataExist(){
            self.setState(state: RocketNotAddedAsFavorite())
        }
        
    }
    
    // Set to state
    func setState(state: RocketFavoriteState){
        self.state = state
    }
    
    // お気に入り情報に当画面のロケット情報が登録されているかチェック
    func isFavoriteDataExist() -> Bool{
        
        print("FavoriteListView - IN - isFavoriteDataExist")

        // Realm
        let realm = try! Realm()
        
        let filterRealm = realm.objects(FavoriteObject.self).filter("id = \(self.id)")
        
        if filterRealm.count == 0{
            print("FavoriteListView - OUT - isFavoriteDataExist - return: false")
            return false
        } else {
            print("FavoriteListView - OUT - isFavoriteDataExist - return: true")
            return true
        }
        
    }

    
    // Check exist ID in UserDefaults
    func checkExistFavorite(){
        
        print("DetailViewController - IN - checkExistFavorite")

        // write check logic
        
        // Comment. reason: Data using RealmDB
//        let id = defaultsForFavorite.integer(forKey: "FavoriteID+\(self.id)")
        
        // Realm Data Check
        let realm = try! Realm()
        let filterRealm = realm.objects(FavoriteObject.self).filter("id = \(self.id)")
        

        print("DetailViewController - checkExistFavorite - ID: \(id)")
        
        // If ID not exist in Realm State set RocketAddedAsFavorite
        if filterRealm.count != 0 {
            print("DetailViewController - checkExistFavorite - IN - IF")
            state = RocketAddedAsFavorite()
            print("DetailViewController - checkExistFavorite - OUT - IF")
        }
        
        print("DetailViewController - OUT - checkExistFavorite")

    }
    
    // Rocket add favorite
    func addafavorite(){
        
        print("DetailViewController - IN - addafavorite")

        // do something
        
        // Comment. reason: Data using RealmDB
//        defaultsForFavorite.set(self.id, forKey: "FavoriteID+\(self.id)")
//        print("DetailViewController - addafavorite - defaultsForFavorite: \(defaultsForFavorite.integer(forKey: "FavoriteID+\(self.id)"))")
        
        // Favorite Data add to Realm
        // Raalm For Favorite
        let author = FavoriteObject()
        
        // Date Formatter Declare
        let formatterString = DateFormatter()

        author.id = self.id
        author.rocketName = self.name
        if self.videoURL == nil{
//            self.videoURL = "Empty"
            self.videoURL?[0] = "Empty"
        }

        // launchDate add to author as String because launchDate declaring Date type
        formatterString.timeZone = TimeZone(identifier: "JST")
        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatterString.locale = Locale(identifier: "ja_JP")
        formatterString.dateStyle = .full
        formatterString.timeStyle = .medium
        author.windowStart = formatterString.string(from: self.launchDate)
        author.windowStart = self.windowStart

        author.windowEnd = self.windowEnd

//        author.videoURL = self.videoURL
//        author.videoURL = self.videoURL?[0] ?? ""
        for data in self.videoURL!{
            let videoUrlList = VideoUrlList()
            videoUrlList.urlList = data
            author.videoUrls.append(videoUrlList)
        }
        

        print("DetailViewController - addafavorite - self.name: \(self.name)")
        print("DetailViewController - addafavorite - self.windowStart: \(self.windowStart)")

        // AddTime set to author
        let addedDate = Date()
        formatterString.timeZone = TimeZone(identifier: "JST")
        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatterString.locale = Locale(identifier: "ja_JP")
        formatterString.dateStyle = .full
        formatterString.timeStyle = .medium
        author.addedDate = formatterString.string(from: addedDate)
        
        print("DetailViewController - addafavorite - author.addedDate: \(author.addedDate)")
        
        author.launchDate = self.launchDate
        
        // 機関名をラベル表示用にするため、Dictionaryから日本語表記名を取得して登録する
        let dicAgencies = DicAgencies()
        let agency = dicAgencies.getAgencyOfJapanese(key: self.agency)
        print("DetailRocketViewController - addafavorite - agency: \(self.agency)")
        author.agency = self.agency
        
        // URL of RocketImage save to
        if let rocketImageURL = self.rocketImageURL{
            author.rocketImageURL = rocketImageURL
        }

        // URL for Cell of RocketImage save to
        author.rocketImageUrlForCell = self.rocketImageUrlForCell
        
        // Mission Name
        author.missionName = self.missionName
        
        // Agency Info URL
        author.agencyInfoUrl = self.agencyURL

        let realm = try! Realm()
        try! realm.write {
            realm.add(author)
        }

        print("DetailViewController - addafavorite - realm:  \(realm.objects(FavoriteObject.self))")

        print("DetailViewController - OUT - addafavorite")

    }
    
    // Rocket remove favorite
    func removeFavorite(){
        
        print("DetailViewController - IN - removeFavorite")

        // do something
        // Comment. reason: Data using RealmDB
//        defaultsForFavorite.removeObject(forKey: "FavoriteID+\(self.id)")
//        print("DetailViewController - removeFavorite - defaultsForFavorite: \(defaultsForFavorite.integer(forKey: "FavoriteID+\(self.id)"))")
        
        
        // Favorite Data remove from Realm
        let realm = try! Realm()
//        let queryId = self.id
//        var queryId: Int!
//        if let id = self.id{
//            queryId = id
//        }
        print("DetailViewController - removeFavorite - queryId:  \(self.id)")
//        print("DetailViewController - removeFavorite - queryId:  \(queryId)")

//        let filterRealm = realm.objects(FavoriteObject.self).filter("id = 1848")
        let filterRealm = realm.objects(FavoriteObject.self).filter("id = \(self.id)")

        print("DetailViewController filterRealm[0].id: \(filterRealm[0].id)")
        print("DetailViewController - removeFavorite - filterRealmCount:  \(filterRealm.count)")
        
        try! realm.write {
            realm.delete(filterRealm)
        }

        print("DetailViewController - removeFavorite - realm:  \(realm.objects(FavoriteObject.self))")

        
        print("DetailViewController - OUT - removeFavorite")

    }

    @IBAction func videoLink(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[0] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var videoLinkOutlet: UIButton!
    
    @IBAction func videoLink2(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[1] ?? "")! as URL,options: [:],completionHandler: nil)

    }
    
    @IBOutlet weak var videoLinkOutlet2: UIButton!
    
    @IBAction func videoLink3(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[2] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var videoLinkOutlet3: UIButton!
    
    @IBAction func videoLink4(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[3] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var videoLinkOutlet4: UIButton!
    
    @IBAction func videoLink5(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[4] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var videoLinkOutlet5: UIButton!
    
    @IBAction func videoLink6(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[5] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var videoLinkOutlet6: UIButton!
    
    @IBAction func videoLink7(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[6] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var videoLinkOutlet7: UIButton!
    
    @IBAction func videoLink8(_ sender: Any) {
        UIApplication.shared.open(URL(string: self.videoURL?[7] ?? "")! as URL,options: [:],completionHandler: nil)
    }
    
    @IBOutlet weak var videoLinkOutlet8: UIButton!
    
    func loadImage(urlString: String) {
        
        // ロケット画像なしの場合は共通のロケット画像を使用するので、
        // ダウンロードせずローカル画像を使用する。
        if urlString == "https://s3.amazonaws.com/launchlibrary/RocketImages/placeholder_1920.png"{
            
            self.imageRocket.image = UIImage(named: "RocketNoImage_1920")
            // UIImageViewのサイズに収まるようにサイズを調整
            self.imageRocket.contentMode = .scaleAspectFill

        }else{
            
            let url = URL(string: urlString)!
            
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageRocket.image = UIImage(data: data!)
                    // UIImageViewのサイズに収まるようにサイズを調整
                    self.imageRocket.contentMode = .scaleAspectFill
//                print(response!)
                }
                
            }.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // ロケット画像を閲覧用のビューに渡す
        if segue.identifier == "imageSendToView"{
            let controller = segue.destination as! RocketImageViewController
            controller.rocketImage = self.imageRocket.image
        }
    }
}
