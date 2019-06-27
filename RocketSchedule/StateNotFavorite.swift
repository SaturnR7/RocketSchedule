//
//  StateNotFavorite.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/06/27.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

// Using State Pettern

protocol RocketFavoriteState {
    func buttonFavoriteTapped (detailViewController: DetailViewController)
}


// ロケット情報が既に登録されている状態からお気に入りを削除する
class RocketAddedAsFavorite: NSObject, RocketFavoriteState{
    func buttonFavoriteTapped(detailViewController: DetailViewController){
        detailViewController.removeFavorite()
        detailViewController.setState(state: RocketNotAddedAsFavorite())
    }
}

// ロケット情報が登録されていない状態でから新たにお気に入り登録する
class RocketNotAddedAsFavorite: NSObject, RocketFavoriteState{
    func buttonFavoriteTapped(detailViewController: DetailViewController){
        detailViewController.addafavorite()
        detailViewController.setState(state: RocketAddedAsFavorite())
    }
}

