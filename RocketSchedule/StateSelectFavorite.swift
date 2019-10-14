//
//  StateSelectFavorite.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/07/21.
//  Copyright © 2019 zilch. All rights reserved.
//

// 「今回は使用しない」リストに表示される○からマルチ選択した場合の処理


//import Foundation
//
//// Using State Pettern
//
//protocol RocketFavoriteSelectState {
//    func buttonTapped (favoriteListView: FavoriteListView)
//}
//
//
//// ロケット情報が既に登録されている状態からお気に入りを削除する
//class FavoriteSelect: NSObject, RocketFavoriteSelectState{
//    func buttonTapped(favoriteListView: FavoriteListView){
//        favoriteListView.setToSelectMode()
//        favoriteListView.setState(state: FavoriteNoSelect())
//    }
//}
//
//// Delete Favorite Data that Data not register in Realm
//// ロケット情報が登録されていない状態でから新たにお気に入り登録する
//class FavoriteNoSelect: NSObject, RocketFavoriteSelectState{
//    func buttonTapped(favoriteListView: FavoriteListView){
//        favoriteListView.setToNormalMode()
//        favoriteListView.setState(state: FavoriteSelect())
//    }
//}

