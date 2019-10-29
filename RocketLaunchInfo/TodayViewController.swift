//
//  TodayViewController.swift
//  RocketLaunchInfo
//
//  Created by Hidemasa Kobayashi on 2019/10/26.
//  Copyright © 2019 zilch. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
//    @IBOutlet weak var labelRocketName: UILabel!
//
//    @IBOutlet weak var labelLaunchTime: UILabel!
//
//    @IBOutlet weak var labelLaunchTime_01: UILabel!
//
//    @IBOutlet weak var rocketImage: UIImageView!
    
    // UI Compornents
    var label_01 = UILabel()
    var launchTimeRemainingLabel = UILabel()
    var rocketNameLabel = UILabel()
    var rocketImage = UIImageView()
    var launchDayLabel = UILabel()
    var launchTimeLabel = UILabel()
    
    // work
    var utcDate: Date!
    var addedDate: Date!
    var workRocketName: String!
    var workLaunchDate: Date!
    var workRocketImageURL: String!
    
    //ユーザーが指定した時間(仮) 分
    let userTimer: Int = 1
    var count = 0
    
    // ロケット名日本語変換クラス
    var rocketEng2Jpn = RocketNameEng2Jpn()
    
    // ImageURL解像度変更クラス
    var replaceImageSizeURL = ReplaceImageSizeURL()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // expandedで拡大可能に
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        // ロケット画像
        imageRocketSet()
        // ロケット名
        labelRocketNameSet()
        // ラベル文言
        label01()
        // 打ち上げ残り時間
        labelLaunchTimeSet()
//        // 打ち上げ予定日
//        labelLaunchPlanDaySet()
//        // 打ち上げ予定時刻
//        labelLaunchPlanTimeSet()

       
        // 次回の打上げ情報ダウンロード・画像のダウンロード
        launchJsonDownload()
        
        
    }
    
    // NCWidgetDisplayModeが変更されるたびに呼ばれるので、ここで拡大時の高さを設定する。
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
           if case .compact = activeDisplayMode {
//               preferredContentSize = maxSize
               preferredContentSize = maxSize
           } else {
               preferredContentSize.height = 300
           }
    }
        
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
    
    // ロケット名
    func labelRocketNameSet() {
        
        // 制約設定時は必須の処理
        // 制約を設定するためレイアウトの矛盾を防ぐ
        rocketNameLabel.translatesAutoresizingMaskIntoConstraints = false

//        rocketNameLabel = UILabel.init(frame: CGRect.init(x: 115,
//                                                          y: 17,
//                                                          width: 200,
//                                                          height: 5))
        
        rocketNameLabel.textAlignment = .left
//        rocketNameLabel.textColor = UIColor.white
        rocketNameLabel.font = UIFont.init(name: "Futura", size: 20)
//        rocketNameLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 26, weight: UIFont.Weight.black)
        // 文字の大きさを自動で変える
        rocketNameLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(self.rocketNameLabel)
        
        // 画像の幅に対して任意の数値に設定、制約を有効にする
        rocketNameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        // 画像の高さに対して任意の数値に設定、制約を有効にする
        rocketNameLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        // ビューに対して上端から何ポイントと離すか定義する
        rocketNameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 17).isActive = true
        // X座標軸の中心を親Viewと合わせる制約を有効にする
        rocketNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 110).isActive = true

    }

    // ラベル文言
    func label01() {
        
        // 制約設定時は必須の処理
        // 制約を設定するためレイアウトの矛盾を防ぐ
        label_01.translatesAutoresizingMaskIntoConstraints = false

//        label_01 = UILabel.init(frame: CGRect.init(x: 115,
//                                                   y: 45,
//                                                   width: 200,
//                                                   height: 5))
        
        label_01.textAlignment = .right
//        label_01.textColor = UIColor.white
        
        label_01.font = UIFont.init(name: "Futura", size: 13)
//        label_01.font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: UIFont.Weight.black)
        self.view.addSubview(self.label_01)
        
        // 画像の幅に対して任意の数値に設定、制約を有効にする
        label_01.widthAnchor.constraint(equalToConstant: 250).isActive = true
        // 画像の高さに対して任意の数値に設定、制約を有効にする
        label_01.heightAnchor.constraint(equalToConstant: 7).isActive = true
        // ビューに対して上端から何ポイントと離すか定義する
        label_01.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        // X座標軸の中心を親Viewと合わせる制約を有効にする
//        label_01.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 110
//        ).isActive = true
        label_01.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15
        ).isActive = true

    }

    // 打ち上げ残り時間
    func labelLaunchTimeSet() {
        
        // 制約設定時は必須の処理
        // 制約を設定するためレイアウトの矛盾を防ぐ
        launchTimeRemainingLabel.translatesAutoresizingMaskIntoConstraints = false

//        launchTimeRemainingLabel = UILabel.init(frame: CGRect.init(x: 115,
//                                                          y: 73,
//                                                          width: 250,
//                                                          height: 10))
        
        launchTimeRemainingLabel.textAlignment = .right
//        launchTimeRemainingLabel.textColor = UIColor.white
//        launchTimeLabel.font = UIFont.init(name: "Futura-Bold", size: 30)
        launchTimeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: UIFont.Weight.black)
        self.view.addSubview(self.launchTimeRemainingLabel)
        
        
        // 画像の幅に対して任意の数値に設定、制約を有効にする
        launchTimeRemainingLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        // 画像の高さに対して任意の数値に設定、制約を有効にする
        launchTimeRemainingLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        // ビューに対して上端から何ポイントと離すか定義する
        launchTimeRemainingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        // X座標軸の中心を親Viewと合わせる制約を有効にする
//        launchTimeRemainingLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 110).isActive = true
        launchTimeRemainingLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true

    }
    
    // 打ち上げ予定日
    func labelLaunchPlanDaySet() {
        
        // 制約設定時は必須の処理
        // 制約を設定するためレイアウトの矛盾を防ぐ
        launchDayLabel.translatesAutoresizingMaskIntoConstraints = false

//        launchDayLabel = UILabel.init(frame: CGRect.init(x: 7,
//                                                          y: 130,
//                                                          width: 150,
//                                                          height: 30))
        launchDayLabel.textAlignment = .right
        launchDayLabel.textColor = UIColor.white
//        rocketNameLabel.font = UIFont.init(name: "Futura-Bold", size: 30)
        launchDayLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: UIFont.Weight.black)
        self.view.addSubview(self.launchDayLabel)
        
        // ビューに対して上端から何ポイントと離すか定義する
        launchDayLabel.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        // X座標軸の中心を親Viewと合わせる制約を有効にする
//        launchDayLabel.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 7).isActive = true
        launchDayLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

    }

    // 打ち上げ予定時刻
    func labelLaunchPlanTimeSet() {
        
        // 制約設定時は必須の処理
        // 制約を設定するためレイアウトの矛盾を防ぐ
        launchTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        launchTimeLabel = UILabel.init(frame: CGRect.init(x: 120,
                                                          y: 330,
                                                          width: 150,
                                                          height: 30))
        launchTimeLabel.textAlignment = .left
        launchTimeLabel.textColor = UIColor.white
//        rocketNameLabel.font = UIFont.init(name: "Futura-Bold", size: 23)
        launchTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: UIFont.Weight.black)
        self.view.addSubview(self.launchTimeLabel)
        
        // ビューに対して上端から何ポイントと離すか定義する
        launchTimeLabel.topAnchor.constraint(equalTo: self.launchDayLabel.bottomAnchor, constant: 10).isActive = true
        // X座標軸の中心を親Viewと合わせる制約を有効にする
        launchTimeLabel.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 120).isActive = true

    }

    // ロケット画像
    func imageRocketSet() {
        
        // 制約設定時は必須の処理
        // 制約を設定するためレイアウトの矛盾を防ぐ
        rocketImage.translatesAutoresizingMaskIntoConstraints = false
        
        // UIImageViewのインスタンスをビューに追加
        self.view.addSubview(rocketImage)

        // 画像ビューの制約を設定する
        // 画像の幅に対して任意の数値に設定、制約を有効にする
        rocketImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        // 画像の高さに対して任意の数値に設定、制約を有効にする
        rocketImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        // ビューに対して上端から何ポイントと離すか定義する
        rocketImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 7).isActive = true
        // X座標軸の中心を親Viewと合わせる制約を有効にする
//        rocketImage.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60).isActive = true
        rocketImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true

    }

    // Rocket LibraryからJsonデータをダウンロード
    func launchJsonDownload(){
        
        print("TodayViewController - launchJsonDownload start")

//        string: "https://launchlibrary.net/1.4/launch?mode=verbose&next=1"){
//        string: "https://launchlibrary.net/1.4/launch?mode=verbose&id=1652"){
        if let url = URL(
            string: "https://launchlibrary.net/1.4/launch?mode=verbose&next=1"){
//            string: "https://launchlibrary.net/1.4/launch?mode=verbose&id=1652"){

            print("launchJsonDownload start inside URL")

            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data, let response = response {
                    print("launchJsonDownload start inside URLSession")
                    print(response)

                    // JSON decode to Struct-Launch
                    let json = try! JSONDecoder().decode(Launch.self, from: data)
                    
//                    print("JSON Data: \(json)")
                    
                    for launch in json.launches {

                        print("name:\(launch.name)")
                        
                        // calendarを日付文字列だ使ってるcalendarに設定
                        let formatterString = DateFormatter()
                        
                        // TimeZoneはUTCにしなければならない。
                        // 理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
                        // 日付を返してしまうため。
                        formatterString.timeZone = TimeZone(identifier: "UTC")
//                        formatterString.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatterString.dateFormat = "MMMM dd, yyyy HH:mm:ss z"
                        
                        // 固定フォーマットで表示
                        // 【info.plist】
                        // Localization native development region：Japan
                        // localeプロパティを設定しないと、日付変換処理でnilが返ってしまう。
                        formatterString.locale = Locale(identifier: "en_US_POSIX")
                        
                        let jsonDate = launch.windowstart
                        print("jsonDate:\(jsonDate)")
                        
                        if let dateString = formatterString.date(from: jsonDate){
//                            print("dateString:\(String(describing: dateString))")
                            
                            formatterString.locale = Locale(identifier: "ja_JP")
                            formatterString.dateStyle = .full
                            formatterString.timeStyle = .medium

                            //ローカル通知登録用の日付をData型でセットする
                            self.utcDate = Date(timeInterval: 0, since: dateString)
                            
                            // システム設定しているタイムゾーンを元にUTCから発射日時を算出する
                            //                            self.addedDate = Date(timeInterval: 60*60*9*1, since: dateString)
                            // TimeRelated.swiftを使った処理だが不要のためコメント化
//                            print("timeintervalValue: \(self.timeintervalValue)")
//                            self.addedDate = Date(timeInterval: self.timeintervalValue, since: dateString)
                            self.addedDate = Date(timeInterval: Double(Calendar.current.timeZone.secondsFromGMT()), since: dateString)

                        }else{
                            print("dateString is nil")
                        }
                        
                        self.workRocketImageURL = launch.rocket.imageURL
                        self.workRocketName = launch.name
                        self.workLaunchDate = self.addedDate
                        print("workLaunchDate", self.workLaunchDate)
                        
                    }

                    
                    // 非同期処理完了後の処理（Jsonダウンロード完了後）
                    DispatchQueue.main.async {
                        
                        // ロケット画像のセット
                        // ImageURLの解像度を480に置き換える
                        let replacedImageURL =
                            self.replaceImageSizeURL.replacingValue(value: self.workRocketImageURL)
                        self.rocketImageSet(imageUrl: replacedImageURL)
                        
                        // ロケット名を日本語に変換してラベルにセット
//                        self.labelRocketName.text =
                        self.rocketNameLabel.text =
                            self.rocketEng2Jpn.checkStringSpecifyRocketName(name: self.workRocketName)

                        //TimeZoneはUTCにしなければならない。
                        //理由は、UTCに指定していないと、DateFormatter.date関数はcurrentのゾーンで
                        //日付を返してしまうため。
                        // Launch Day
                        let formatterString = DateFormatter()
                        formatterString.timeZone = TimeZone(identifier: "UTC")
                        formatterString.dateFormat = "yyyy/MM/dd (EEE)"
                        formatterString.locale = Locale(identifier: "ja_JP")
                        print("launchJsonDownload - DispatchQueue - launchDate: \(self.workLaunchDate)")
                        self.launchDayLabel.text = "\(formatterString.string(from: self.workLaunchDate))"
                        // Launch Time
                        let formatterLaunchTime = DateFormatter()
                        formatterLaunchTime.timeZone = TimeZone(identifier: "UTC")
                        formatterLaunchTime.locale = Locale(identifier: "ja_JP")
                        formatterLaunchTime.dateStyle = .none
                        formatterLaunchTime.timeStyle = .medium
                        self.launchTimeLabel.text = "\(formatterLaunchTime.string(from: self.workLaunchDate))"

                        print("タイムゾーンを加味した日付", Date(timeInterval: Double(Calendar.current.timeZone.secondsFromGMT()), since: Date()))
                        
                        let formatterSecond = DateComponentsFormatter()
                        let date = formatterSecond.string(from: 163920)
                        print("秒から日付を表示", date)
                        
                        self.timerFunc()
                        
                    }
                    
                    print("launchJsonDownload end inside")

                } else {
                    print(error ?? "Error")
                }
            })
            
            task.resume()

            }

        print("TodayViewController - launchJsonDownload end")
    }

    
    var intervalSecond: TimeInterval = 0
    // 秒から経過時間表示用
    let formatterSecond = DateComponentsFormatter()
    
    // タイマー作成
    func timerFunc(){
        
//        count = userTimer * 60
        
        formatterSecond.unitsStyle = .positional
        formatterSecond.allowedUnits = [.day, .hour, .minute, .second]
        label_01.text = "打ち上げまであと"

        let intervalDate = self.workLaunchDate.timeIntervalSince(Date(timeInterval: Double(Calendar.current.timeZone.secondsFromGMT()), since: Date()))
        print("timerFunc - intervalDate", intervalDate)
        
        intervalSecond = intervalDate
        
        Timer.scheduledTimer(
            timeInterval: 1.0,
            target      : self,
            selector    : #selector(self.timerAction(sender:)),
            userInfo    : nil,
            repeats     : true
        )
            
        .fire()
        
    }
    
    var displayDate: Date!
    
    //タイマーの処理
    @objc func timerAction(sender:Timer){
        
        
        
        if intervalSecond != 0 {

            let displayDate = formatterSecond.string(from: intervalSecond)
            print("timerAction - displayDate",displayDate!)

            launchTimeRemainingLabel.text = displayDate
            intervalSecond -= 1
        }

        else {
            
//            labelLaunchTime_01.isHidden = true

            sender.invalidate()

        }
        
//        if count >= 60 {
//            let minuteCount = count / 60
//
//            labelLaunchTime.text = String(minuteCount)
//            labelLaunchTime_01.text = "分"
//            count -= 1
//        }
//
//        else if count < 60{
//            labelLaunchTime.text = String(count)
//            labelLaunchTime_01.text = "秒"
//            if count == 0{
//                sender.invalidate()
//            }
//            count -= 1
//        }
    }
    
    func timeCalculationDifference(launchTime: Date) -> DateComponents{
        
        let cal = Calendar(identifier: .gregorian)
        // 現在日時を dt に代入
        let currentDate = Date()
        // dt2 - dt1 を計算
        let diff1 = cal.dateComponents([.second], from: currentDate, to: launchTime)
        // 書式を設定する
        let formatter = DateComponentsFormatter()
        //let formatter = DateFormatter()
        // 表示単位を指定
        formatter.unitsStyle = .positional
        // 表示する時間単位を指定
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        // 日付形式を指定
        //formatter.dateFormat = "yyyy/MM/dd (EEE)"
        // 設定した書式にしたがって表示
        print("Time Difference", formatter.string(from: diff1)!)
        
        return diff1
    }
    
    func rocketImageSet(imageUrl: String) {

        print("rocketImageSet - start")

        // httpからダウンロードするパターン
        let url = URL(string: imageUrl)!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                print("loadImage data: \(data)")

//                print(response!)
                
                let original = UIImage(data: data!)
                
                self.rocketImage.image =
                    self.resize(image: original!, width: Double(original!.size.width))

                
//                // こういう荒業は使ってはいけない！！
//                // 該当のロケット画像なしの場合は、共通の画像が使用されている、
//                // しかし、フレームサイズでクロップすると画像以外の余白がセルに表示されてしまい
//                // 見栄えがひどい、共通の画像のURLが渡ってきたときは、固定値でクロップして当現象を回避する
//                if imageUrl == "https://s3.amazonaws.com/launchlibrary/RocketImages/placeholder_480.png"{
//
//                    self.rocketImage.image =
//                        original?.cropping(to: CGRect(
//                            x:      Int(30),
//                            y:      Int(30),
//                            width:  Int(self.rocketImage.frame.maxX),
//                            height: Int(self.rocketImage.frame.maxY)))
//                }else{
//
//                    self.rocketImage.image =
//                        original?.cropping(to: CGRect(
//                            x:      Int(original!.size.width/13),
//                            y:      Int(original!.size.height/6),
//                            width:  Int(self.rocketImage.frame.maxX),
//                            height: Int(self.rocketImage.frame.maxY)))
//                }
                
            }
            
        }.resume()
        
    }
    
    func resize(image: UIImage, width: Double) -> UIImage {
            
        // オリジナル画像のサイズからアスペクト比を計算
        let aspectScale = image.size.height / image.size.width
        
        // widthからアスペクト比を元にリサイズ後のサイズを取得
        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
        
        // リサイズ後のUIImageを生成して返却
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
        
    }
    
}

extension UIImage {
    
    func cropping(to: CGRect) -> UIImage? {
        
        var opaque = false
        
        if let cgImage = cgImage {
            
            switch cgImage.alphaInfo {
            case .noneSkipLast, .noneSkipFirst:
                opaque = true
            default:
                break
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(to.size, opaque, scale)
        
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
}

extension UIImage{
    
    // Resizeのクラスメソッドを作る.
    class func resizeUIImage(image : UIImage,width : CGFloat, height : CGFloat)-> UIImage!{
        
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        // コンテキストに画像を描画する.
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
