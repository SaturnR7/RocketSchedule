//
//  IndicatorView.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/09/26.
//  Copyright © 2019 zilch. All rights reserved.
//

import UIKit

class IndicatorView: UIView {
    
    // Indicatorの動作フラグです
    //  - true: Indicatorの動作を停止します
    //  - false: Indicatorの動作を開始します
    var finished = true
    
    @IBOutlet weak var indicatorPin: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    
    // Indicatorを開始します
    //
    func start() {
        finished = false
        running()
    }
    
    
    // Indicator animationを実行します
    func running() {
        
        if finished == true {
            return
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
            self.indicatorPin.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.indicatorPin.transform = CGAffineTransform.identity
        }, completion: { completed in
            self.running()
        })
    }
    
    func stop() {
        finished = true
    }

    private func loadNib(){
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
