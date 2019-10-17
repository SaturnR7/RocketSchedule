//
//  RocketImageViewController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/08/30.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit
import Accounts

class RocketImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var rocketImageView: UIImageView!
    
    @IBOutlet weak var rocketImageScrollView: UIScrollView!
    
    // When Image Long Press below action
    @IBAction func rocketImageLongPressAction(_ sender: UILongPressGestureRecognizer) {
        
        // 共有メニューの表示
        // 実装となると、twitter,facebook,save imageなど権限設定と動作確認が必要になる
        shareImage()
    }
    
    @IBAction func imageShareButton(_ sender: UIBarButtonItem) {
        
        shareImage()
    }
    
    @IBOutlet weak var imageShareButtonOutlet: UIBarButtonItem!
    
    
    @IBOutlet weak var imageToolBar: UIToolbar!
    
    var rocketImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーのアイテムの色　（戻る　＜）
        self.navigationController?.navigationBar.tintColor = .white
        // ナビゲーションバーのタイトル
        self.navigationItem.title = ""
        // バックボタンのタイトルを設定
        // 遷移先のバックボタンにタイトルを設定する場合は、title: に文字を設定する。
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        rocketImageScrollView.delegate = self
        
        // ステータスバーのタップ時に先頭移動の動作を無効にする
        rocketImageScrollView.scrollsToTop = false

        rocketImageView.image = self.rocketImage
        
        // スクロールビューが拡大縮小できるさ値を設定
        // minimumZoomScale：縮小できる最大値（値を下げると限りなく縮小できる）
        // maximumZoomScale：拡大できる最大値（値を上げるとより拡大できる）
        rocketImageScrollView.minimumZoomScale = 1.0
        rocketImageScrollView.maximumZoomScale = 7.0
        
        
        let doubleTapGesture =
            UITapGestureRecognizer(target: self, action:#selector(self.doubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.rocketImageView.addGestureRecognizer(doubleTapGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.rocketImageView
    }
    
    @objc func doubleTap(gesture: UITapGestureRecognizer) -> Void {
        //print(self.myScrollView.zoomScale)
        if (self.rocketImageScrollView.zoomScale < self.rocketImageScrollView.maximumZoomScale) {
            let newScale = self.rocketImageScrollView.zoomScale * 3
            let zoomRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view))
            self.rocketImageScrollView.zoom(to: zoomRect, animated: true)
        } else {
            self.rocketImageScrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    func zoomRectForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        let size = CGSize(
            width: self.rocketImageScrollView.frame.size.width / scale,
            height: self.rocketImageScrollView.frame.size.height / scale
        )
        return CGRect(
            origin: CGPoint(
                x: center.x - size.width / 2.0,
                y: center.y - size.height / 2.0
            ),
            size: size
        )
    }
    
    func shareImage(){
        
        let activityItems = [self.rocketImageView.image]
        
        let avc = UIActivityViewController(activityItems: activityItems as! [UIImage], applicationActivities: nil)
        
        self.present(avc, animated: true, completion: nil)
    }
    
}
