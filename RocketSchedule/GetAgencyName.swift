//
//  GetAgencyName.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/09/19.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

// Launch.swiftに格納されているAgency名を取得するクラス
class GetAgencyName {
    
    // 機関名の取得
    // Launch情報(Mode=Verbose)に入っている各機関名の場所
    // １．Location - Pads - Agencies：打ち上げ場所を提供する機関（未確定情報）
    // ２．Rocket - Agencies：ロケットを提供する機関
    // ３．Rocket - Missionss - Agencies：ロケットに搭載している衛星などを提供する機関
    // ４．Lsp：ロケットを製造している機関
    //
    // 機関名取得の優先順位（４はロケットを製造してる機関名なので対象外）
    //     ２＞３＞１
    //
    func getAgencyNameInSingleLaunch(launchData launch: Launch.Content) -> String {
        
        print("GetAgencyName - getAgencyNameInSingleLaunch Start")

        // ２．Rocket - Agencies の機関名を取得
        // 機関名が格納されていたらAgencyのabbrevを返却
        if !launch.rocket.agencies!.isEmpty{
            if let agency = launch.rocket.agencies?[0]{
                print("Rocket - Agencies : \(agency.abbrev)")
                print("GetAgencyName - getAgencyNameInSingleLaunch End")
                return agency.abbrev
            }
        }

        // １．Location - Pads - Agencies の機関名を確認
        // 機関名が格納されていたらAgencyのabbrevを返却
        if !launch.location.pads[0].agencies!.isEmpty{
            if let agency = launch.location.pads[0].agencies{
                print("Location - Pads - Agencies : \(agency[0].abbrev)")
                print("GetAgencyName - getAgencyNameInSingleLaunch End")
                return agency[0].abbrev
            }
        }
        
        // ３． Missionss - Agencies の機関名を取得
        // 機関名が格納されていたらAgencyのabbrevを返却
        if !launch.missions!.isEmpty{
            if let agency = launch.missions?[0].agencies?[0]{
                print("Missionss - Agencies : \(agency.abbrev)")
                print("GetAgencyName - getAgencyNameInSingleLaunch End")
                return agency.abbrev
            }
        }
        
        print("GetAgencyName - getAgencyNameInSingleLaunch End")
        // 機関名が格納されていなかったら”ー”を返却
        return "ー"
        
    }
}
