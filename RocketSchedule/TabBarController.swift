//
//  TabBarController.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/10/25.
//  Copyright © 2019 zilch. All rights reserved.
//

import UIKit
import TransitionableTab

class TabBarController: UITabBarController {

    // アニメーション設定用
//    var type: Type = .custom
    var type: Type = .custom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("TabBarController - viewDidLoad - type: \(type)")

        self.delegate = self as UITabBarControllerDelegate
    }
    
}

extension TabBarController: TransitionableTab {

    // カスタム
    // プロトコル継承
    private func fromTransitionAnimation(layer: CALayer, direction: Direction) -> CAAnimation {
        
        print("TabBarController - fromTransitionAnimation - type: \(type)")
        
        switch type {
        case .move: return DefineAnimation.move(.from, direction: direction)
        case .scale: return DefineAnimation.scale(.from)
        case .fade: return DefineAnimation.fade(.from)
        case .custom:
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = 5
            animation.toValue = -layer.frame.height
            return animation
        }
    }
    
    private func toTransitionAnimation(layer: CALayer, direction: Direction) -> CAAnimation {
        
        print("TabBarController - toTransitionAnimation - type: \(type)")

        switch type {
        case .move: return DefineAnimation.move(.to, direction: direction)
        case .scale: return DefineAnimation.scale(.to)
        case .fade: return DefineAnimation.fade(.to)
        case .custom:
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = layer.frame.height
            animation.toValue = 10
            return animation
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
    
}

// 遷移モード
enum Type: String {
    
    case move
    case fade
    case scale
    case custom
    
    static var all: [Type] = [.move, .scale, .fade, .custom]
}

