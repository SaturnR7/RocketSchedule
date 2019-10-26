//
//  AsyncImageView.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/07/24.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation
import UIKit

class AsyncImageView {
    
    var image: UIImage?


//    func loadImage(urlString: String) {
    func loadImage(urlString: String) -> UIImage {

        let url = URL(string: urlString)!

        URLSession.shared.dataTask(with: url) {(data, response, error) in

            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
                print(response!)
            }

            }.resume()

        return (self.image!)
    }

}

