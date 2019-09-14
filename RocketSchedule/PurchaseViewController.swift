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

    private let productIdentifiers : [String] = ["RocketMilo_tip_01"]
    
    @IBOutlet weak var labelAboutTip: UILabel!
    
    @IBAction func buttonPurchase_1(_ sender: Any) {

        // SwiftyStorekit
        purchaseProduct(productId: productIdentifiers[0])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        labelAboutTip.numberOfLines = 5
        labelAboutTip.text =
        "ロケットミロは、どんなロケットがいつ打ち上がるか、\n画像・映像を交えてロケットを知ってもらいたい\nという"
        
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
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
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

}
