//
//  ReplaceImageSizeURL.swift
//  RocketLaunchInfo
//
//  Created by Hidemasa Kobayashi on 2019/10/28.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

// class か structか、どっちでもいい
class ReplaceImageSizeURL {
    
    let imageSize =
        ["_640",
         "_720",
         "_768",
         "_800",
         "_960",
         "_1024",
         "_1080",
         "_1280",
         "_1440",
         "_1920",
         "_2560"]
    
    // ImageURLの解像度を[480]に置き換える
    func replacingValue(value: String) -> String {
        
        print("Before: \(value)")
        
        for data in imageSize {
            
            if value.contains(data){
                
                let result = value.replacingOccurrences(of: data, with: "_320")
                
                print("Infor After: \(result)")

                return result
            }
        }
        
        print("Outfor After: \(value)")
        return value
    }
}
