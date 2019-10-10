//
//  GetAgencyName.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/09/19.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

// Launch.swiftに格納されているAgencyを取得するクラス
class GetElementLaunch {
    
    // 機関名の取得
    // Launch情報(Mode=Verbose)に入っている各機関名の場所
    // １．Location - Pads - Agencies：打ち上げ場所を提供する機関（未確定情報）
    // ２．Rocket - Agencies：ロケットを提供する機関
    // ３．Rocket - Missionss - Agencies：ミッションコントロールを行っている機関
    //                                   ロケットに搭載している衛星などを提供する機関
    // ４．Lsp：ロケットを製造している機関
    //
    // 機関取得の優先順位（４はロケットを製造してる機関なので対象外）
    //     ２＞３＞１
    //
    //   取得優先順位の変更履歴
    //      2019/10/10:３>２>１
    //                 ミッションコントロールに基点とすると、Agencyは３の機関を最優先表示させることが望ましい
    //
    func getAgencyNameInSingleLaunch(launchData launch: Launch.Content) -> [String] {
        
        print("GetAgencyName - getAgencyNameInSingleLaunch Start")

        // ３． Missionss - Agencies の項目を取得
        // 機関名が格納されていたらAgencyのabbrevを返却
        if !(launch.missions!.isEmpty){
            if let element = launch.missions?[0].agencies{
                if !element.isEmpty{
                    var element = element[0]
                    
                    // element.infoURLsの空チェック
                    // 空の場合は配列を作る
                    if element.infoURLs!.isEmpty{
                        element.infoURLs!.append("")
                    }
                    
                    print("Missionss - Agencies - abbrev: \(element.abbrev)")
                    print("Missionss - Agencies - infoURLs[0]: \(element.infoURLs?[0])")
                    print("GetAgencyName - getAgencyNameInSingleLaunch End")
                    return [element.abbrev,
                            element.name,
                            element.infoURLs?[0] ?? ""]
                }
            }
        }

        // ２．Rocket - Agencies の項目を取得
        // 機関名が格納されていたらAgencyのabbrevを返却
        if launch.rocket.agencies != nil{
            if let element = launch.rocket.agencies{
                if !element.isEmpty{
                    var element = element[0]
                    
                    // element.infoURLsの空チェック
                    // 空の場合は配列を作る
                    if element.infoURLs!.isEmpty{
                        element.infoURLs!.append("")
                    }
                    
                    print("Rocket - Agencies - abbrev: \(element.abbrev)")
                    print("Rocket - Agencies - infoURLs[0]: \(element.infoURLs?[0])")
                    print("GetAgencyName - getAgencyNameInSingleLaunch End")
                    return [element.abbrev,
                            element.name,
                            element.infoURLs?[0] ?? ""]
                }
            }
        }
            

        // １．Location - Pads - Agencies の項目を確認
        // 機関名が格納されていたらAgencyのabbrevを返却
        if let element = launch.location.pads[0].agencies{
            if !element.isEmpty{
                var element = element[0]
                
                // element.infoURLsの空チェック
                // 空の場合は配列を作る
                if element.infoURLs!.isEmpty{
                    element.infoURLs!.append("")
                }

                print("Location - Pads - Agencies - abbrev: \(element.abbrev)")
                print("Location - Pads - Agencies - infoURLs[0]: \(element.infoURLs?[0])")
                print("GetAgencyName - getAgencyNameInSingleLaunch End")
                return [element.abbrev,
                        element.name,
                        element.infoURLs?[0] ?? ""]
            }
        }
        
        print("GetAgencyName - getAgencyNameInSingleLaunch End")
        // 機関名が格納されていなかったら”ー”を返却
        return ["ー",
                "",
                ""]
        
    }
    
//    func elementInfoUrlCheck(elementInfoURLs: [String]) -> [String]{
//
//        // infoURLsがemptyの場合は、""を返す
//        if elementInfoURLs.isEmpty{
//
//            let result:[String] = [""]
//            return result
//
//        }else{
//
//            return elementInfoURLs
//        }
//    }
}
