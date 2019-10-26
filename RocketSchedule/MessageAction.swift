//
//  MessageAction.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/10/25.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import SwiftMessages

// SwiftMessagesライブラリを使ったメッセージ表示
class MessageAction {
    
    // Bottom Message Card
    // 下からメッセージ画面が表示される
    func bottomMessage(argTitle: String, argBody: String, argDuration: TimeInterval) {
        
        // Basic
        let messageView: MessageView = MessageView.viewFromNib(layout: .messageView)
//        messageView.configureBackgroundView(width: 350)
//        messageView.configureContent(title: "通知登録しました", body: "打上げ時刻は変更になる可能性があります", iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "") { _ in
//            SwiftMessages.hide()
//        }
        messageView.configureContent(title: argTitle, body: argBody)
//        messageView.configureContent(body: "通知登録しました" )
        messageView.button?.isHidden = true
//        messageView.titleLabel?.tintColor = .white
//        messageView.bodyLabel?.tintColor = .white

        // Theme message elements with the warning style.
        messageView.configureTheme(.info)
        messageView.configureTheme(backgroundColor: .white, foregroundColor: .white)

        messageView.backgroundView.backgroundColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
//        messageView.backgroundView.layer.cornerRadius = 10
        
        // Config
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        config.duration = .seconds(seconds: argDuration)
//        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)

        SwiftMessages.show(config: config, view: messageView)
    }
    
    // お気に入り0件用のメッセージ表示
    func favoriteZeroMessage() {
        
        // Basic
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 350)
//        messageView.configureContent(title: "お気に入りのロケット情報を登録しましょう", body: "今日の天気はです", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "閉じる") { _ in
//            SwiftMessages.hide()
//        }
        messageView.configureTheme(backgroundColor: .white, foregroundColor: UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1))
        messageView.configureContent(title: "お気に入り登録しましょう", body: "過去の打上げ画面の☆をタップ", iconImage: UIImage(named: "01_ResultView")!, iconText: nil, buttonImage: nil, buttonTitle: "閉じる") { _ in
                    SwiftMessages.hide()
            }
        messageView.backgroundView.backgroundColor = UIColor.init(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        
        // テキストの色を指定
        messageView.titleLabel?.textColor = .white
        messageView.bodyLabel?.textColor = .white
        
        // 画像をメッセージ画面の上端から何ポイントと離すか定義する
        messageView.iconImageView?.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 25).isActive = true
        messageView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        // Config
        var config = SwiftMessages.defaultConfig
        
        // Disable the interactive pan-to-hide gesture.
        config.interactiveHide = false

        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    
}
