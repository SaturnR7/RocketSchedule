//
//  PurchaseViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/09/12.
//  Copyright © 2019 zilch. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class PurchaseViewController: UIViewController {

    private let productIdentifiers : [String] =
        ["RocketMilo_tip_consumable_01",
         "RocketMilo_tip_consumable_02",
         "RocketMilo_tip_consumable_03"]
    
    @IBOutlet weak var labelAboutTip: UILabel!
    
    // 課金ボタン：Outlet
    @IBOutlet weak var buttonPurchase_1_outlet: UIButton!
    @IBOutlet weak var buttonPurchase_2_outlet: UIButton!
    @IBOutlet weak var buttonPurchase_3_outlet: UIButton!
    
    // 課金後メッセージ
    @IBOutlet weak var purchasedMessage: UILabel!
    
    // 課金ボタン：Action
    @IBAction func buttonPurchase_1(_ sender: Any) {
        
        // ナビゲーションバーの戻るボタン ＜ を一時的に非表示にする（誤操作を防ぐため）
        self.navigationItem.hidesBackButton = true

        // ボタンの状態を処理中に変更する
        buttonPurchase_1_outlet.setTitle("処理中", for: .normal)
        
//        buttonPurchase_1_outlet.tintColor =
//            UIColor.init(red: 31/255, green: 144/255, blue: 255/255, alpha: 1)

        // 課金ボタンを無効にする（ボタンを誤タップさせないため）
        buttonPurchase_1_outlet.isEnabled = false
        buttonPurchase_2_outlet.isEnabled = false
        buttonPurchase_3_outlet.isEnabled = false
        
        
        // SwiftyStorekit
        purchaseProduct(productId: productIdentifiers[0])
        
    }
    @IBAction func buttonPurchase_2(_ sender: Any) {
        
        // ナビゲーションバーの戻るボタン ＜ を一時的に非表示にする（誤操作を防ぐため）
        self.navigationItem.hidesBackButton = true

        // ボタンの状態を処理中に変更する
        buttonPurchase_2_outlet.setTitle("処理中", for: .normal)
        
        // 課金ボタンを無効にする（ボタンを誤タップさせないため）
        buttonPurchase_1_outlet.isEnabled = false
        buttonPurchase_2_outlet.isEnabled = false
        buttonPurchase_3_outlet.isEnabled = false
        
        // SwiftyStorekit
        purchaseProduct(productId: productIdentifiers[1])

    }
    @IBAction func buttonPurchase_3(_ sender: Any) {
        
        // ナビゲーションバーの戻るボタン ＜ を一時的に非表示にする（誤操作を防ぐため）
        self.navigationItem.hidesBackButton = true
        
        // ボタンの状態を処理中に変更する
        buttonPurchase_3_outlet.setTitle("処理中", for: .normal)
        
        // 課金ボタンを無効にする（ボタンを誤タップさせないため）
        buttonPurchase_1_outlet.isEnabled = false
        buttonPurchase_2_outlet.isEnabled = false
        buttonPurchase_3_outlet.isEnabled = false

        // SwiftyStorekit
        purchaseProduct(productId: productIdentifiers[2])

    }
    
    // 「購入履歴」ボタン（不使用）
    @IBAction func buttonReceipt(_ sender: Any) {
        // SwiftyStorekit
        verifyReceipt()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // ナビゲーションバーのアイテムの色　（戻る　＜）
        self.navigationController?.navigationBar.tintColor = .white

        labelAboutTip.numberOfLines = 0
        labelAboutTip.sizeToFit()
        labelAboutTip.text = "ロケットミロは、ロケットの魅力をたくさんの\n人に知ってもらいたいという思いから開発しま\nした。\n\n今後もこのアプリをより良くしていきます。\n\nもし、チップをいただけたら泣いて喜びます😊"
//        "ロケットミロは、ロケットの魅力をたくさんの人\nに知ってもらいたいという思いから開発しま\nした。\n\n本アプリは、広告・有料化する予定はありません\n。\n\n今後もこのアプリをより良くしていきます。\n\nもし、チップをいただけたら泣いて喜びます。そ\nしてモチベーションを更に上げてより良いもの\nを作っていけます😊"
        
        // 課金ボタン名を設定する
        buttonPurchase_1_outlet.setTitle("¥120", for: .normal)
        buttonPurchase_2_outlet.setTitle("¥240", for: .normal)
        buttonPurchase_3_outlet.setTitle("¥480", for: .normal)
        
        // 課金後メッセージを表示する
        purchasedMessage.isHidden = true

        // SwiftyStorekit
        // プロダクト情報を取得する
        getProductsInfo(productId: productIdentifiers[0])
        
    }
    
    // SwiftyStorekit
    func getProductsInfo(productId: String){

        // プロダクト情報（価格情報）を取得する
        // 価格情報は、itunes connectのapp内課金で登録した内容をAppleから受信している
        SwiftyStoreKit.retrieveProductsInfo([productId]) { result in
            if let product = result.retrievedProducts.first {

                print("Product: \(product.localizedDescription), price: \(product.price)")

            } else if let invalidProductId = result.invalidProductIDs.first {
                //                print("Invalid product identifier: \(invalidProductId)")
            } else {
                //                print("Error: \(result.error)")
            }
        }
    }
    
    // SwiftyStorekit
    func purchaseProduct(productId: String){

        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                
                print(self.buttonPurchase_1_outlet.state)
                print(self.buttonPurchase_2_outlet.state)
                print(self.buttonPurchase_3_outlet.state)

                // ナビゲーションバーの戻るボタン ＜ を表示にする
                // （課金ボタンタップ時に一時的に非表示にしていたため、非表示を解除する）
                self.navigationItem.hidesBackButton = false

                self.buttonPurchase_1_outlet.setTitle("¥120", for: .normal)
                self.buttonPurchase_2_outlet.setTitle("¥240", for: .normal)
                self.buttonPurchase_3_outlet.setTitle("¥480", for: .normal)
                self.buttonPurchase_1_outlet.isEnabled = true
                self.buttonPurchase_2_outlet.isEnabled = true
                self.buttonPurchase_3_outlet.isEnabled = true

//                // ボタン名を処理中から元に戻す
//                if self.buttonPurchase_1_outlet.state == .normal{
//                    self.buttonPurchase_1_outlet.setTitle("¥120", for: .normal)
//                    // 他の課金ボタンを有効にする（元に戻す）
//                    self.buttonPurchase_1_outlet.isEnabled = true
//                    self.buttonPurchase_2_outlet.isEnabled = true
//                    self.buttonPurchase_3_outlet.isEnabled = true
//
//                }else if self.buttonPurchase_2_outlet.state == .normal{
//                    self.buttonPurchase_2_outlet.setTitle("¥240", for: .normal)
//                    // 他の課金ボタンを有効にする（元に戻す）
//                    self.buttonPurchase_1_outlet.isEnabled = true
//                    self.buttonPurchase_2_outlet.isEnabled = true
//                    self.buttonPurchase_3_outlet.isEnabled = true
//
//                }else if self.buttonPurchase_3_outlet.state == .normal{
//                    self.buttonPurchase_3_outlet.setTitle("¥480", for: .normal)
//                    // 他の課金ボタンを有効にする（元に戻す）
//                    self.buttonPurchase_1_outlet.isEnabled = true
//                    self.buttonPurchase_2_outlet.isEnabled = true
//                    self.buttonPurchase_3_outlet.isEnabled = true
//
//                }
                
                // 課金後メッセージを表示する
                self.purchasedMessage.isHidden = false
                
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled:

                    // ナビゲーションバーの戻るボタン ＜ を表示にする
                    // （課金ボタンタップ時に一時的に非表示にしていたため、非表示を解除する）
                    self.navigationItem.hidesBackButton = false

                    self.buttonPurchase_1_outlet.setTitle("¥120", for: .normal)
                    self.buttonPurchase_2_outlet.setTitle("¥240", for: .normal)
                    self.buttonPurchase_3_outlet.setTitle("¥480", for: .normal)
                    self.buttonPurchase_1_outlet.isEnabled = true
                    self.buttonPurchase_2_outlet.isEnabled = true
                    self.buttonPurchase_3_outlet.isEnabled = true

//                        // ボタン名を処理中から元に戻す
//                        if self.buttonPurchase_1_outlet.state == .normal{
//                            self.buttonPurchase_1_outlet.setTitle("¥120", for: .normal)
//                            // 他の課金ボタンを有効にする（元に戻す）
//                            self.buttonPurchase_1_outlet.isEnabled = true
//                            self.buttonPurchase_2_outlet.isEnabled = true
//                            self.buttonPurchase_3_outlet.isEnabled = true
//
//                        }else if self.buttonPurchase_2_outlet.state == .normal{
//                            self.buttonPurchase_2_outlet.setTitle("¥240", for: .normal)
//                            // 他の課金ボタンを有効にする（元に戻す）
//                            self.buttonPurchase_1_outlet.isEnabled = true
//                            self.buttonPurchase_2_outlet.isEnabled = true
//                            self.buttonPurchase_3_outlet.isEnabled = true
//
//                        }else if self.buttonPurchase_3_outlet.state == .normal{
//                            self.buttonPurchase_3_outlet.setTitle("¥480", for: .normal)
//                            // 他の課金ボタンを有効にする（元に戻す）
//                            self.buttonPurchase_1_outlet.isEnabled = true
//                            self.buttonPurchase_2_outlet.isEnabled = true
//                            self.buttonPurchase_3_outlet.isEnabled = true
//
//                        }
                    
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
                
            }
        }
    }
    
    // SwiftyStorekit
    func restorePurchased(){
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            
//            if results.restoreFailedPurchases.count > 0 {
//                print("Restore Failed: \(results.restoreFailedPurchases)")
//            }
//            else if results.restoredPurchases.count > 0 {
//                print("Restore Success: \(results.restoredPurchases)")
//            }
//            else {
//                print("Nothing to Restore")
//            }
            
            for product in results.restoredPurchases {
                
                print("Restore Success: \(product)")

                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }

                if product.productId == "プロダクトID1" {
                    // プロダクトID1のリストア後の処理を記述する
                } else if product.productId == "プロダクトID2" {
                    // プロダクトID2のリストア後の処理を記述する
                }

            }
            
        }
    }
    
    // SwiftyStorekit
    func verifyReceipt(){
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            switch result {
            case .success(let receipt):
                let productId = self.productIdentifiers[0]
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }

}
