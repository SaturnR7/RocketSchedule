//
//  CopyUILabel.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/08/29.
//  Copyright © 2019 zilch. All rights reserved.
//

import UIKit

class CopyUILabel: UILabel {
    
    // イニシャライザ
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.copyInit()
    }
    
    // イニシャライザ
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.copyInit()
    }
    
    func copyInit() {
        
        self.isUserInteractionEnabled = true
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(CopyUILabel.showMenu(sender:))))
    }
    
    @objc func showMenu(sender:AnyObject?) {
        
        self.becomeFirstResponder()
        
        let contextMenu = UIMenuController.shared
        
        if !contextMenu.isMenuVisible {
            
            contextMenu.setTargetRect(self.bounds, in: self)
            contextMenu.setMenuVisible(true, animated: true)
        }
    }
    
    override func copy(_ sender: Any?) {
        
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = text
        
        let contextMenu = UIMenuController.shared
        contextMenu.setMenuVisible(false, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
    
}
