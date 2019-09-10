//
//  RocketNameEng2Jpn.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/08/04.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

// class か structか、どっちでもいい
class RocketNameEng2Jpn {
    
    // 英語のロケット名を日本語の文字列に変換して呼び出し元へ返却する。
    // 引数で受け取った前方文字列が定数に含まれている場合、
    // 定数の英語ロケット名をキーとして日本語の文字列取得して返す。
    func checkStringSpecifyRocketName (name: String) -> String{
        
        // 引数の文字列を、小文字の定数に一致させるため、すべて小文字に変換する。
        // 定数を小文字にした理由は、取得データに大文字が混入している可能性があるため。
        let lowerString = name.lowercased()
        // 一致判定用
        var isRocketMatch = false
        // 定数に格納されている文字列分繰り返す。
        for data in rocketNames{
            // 引数の文字列が定数の文字列に含まれているか判定する。
            // 判定方法は引数文字列の前方一致で確認。
            if lowerString.contains(data){
                isRocketMatch = true
                return rocketNameEng2Jpn[data] ?? name
            }
        }
        
        // いずれのロケット名に一致しない場合は、引数name（英語名）をそのまま返却する。
        if isRocketMatch == false{
            return name
        }
    }
    
    func getMissionName(name: String) -> String {
        
        let result = separateString(originalName: name, separateString: "|")
        
        if result[1] != ""{
            return result[1].trimmingCharacters(in: .whitespaces)
        }else{
            return name
        }
    }
    
    
    func separateString (originalName name: String, separateString target: String) -> [String]{
        
        return name.components(separatedBy: target)

    }
    
    // この処理のデメリットは、ロケット名が増えるたびに英語ロケットをrocketNamesと
    // rocketNameEng2Jpnの二つに二重で登録しなければいけない。
    
    // ロケット名を追加する場合は、小文字で英語文字列を配列の最後に地下する。
    private let rocketNames
        = [
            "soyuz",
            "falcon 9",
            "falcon9",
            "falcon heavy",
            "falconheavy",
            "proton",
            "ariane",
            "atlas",
            "rokot",
            "delta",
            "vega",
            "longmarch",
            "long march",
            "h-iia",
            "h-iib",
            "epsilon",
            "electron",
            "saturn",
            "kuaizhou",
            "pslv",
            "zhuque",
            "gslv",
            "antares",
            "simorgh",
            "safir",
            "os-m1",
            "hyperbola",
            "smart dragon",
            "smartdragon",
            "gemini",
            "vostok",
            "voskhod"
        ]
    
    // ロケット名を追加する場合は、小文字で英語文字列と日本語名を配列の最後に地下する。
    private let rocketNameEng2Jpn: [String:String]
        = [
            "soyuz":"ソユーズ",
            "falcon 9":"ファルコン9",
            "falcon9":"ファルコン9",
            "falcon heavy":"ファルコンヘビー",
            "falconheavy":"ファルコンヘビー",
            "proton":"プロトン",
            "ariane":"アリアン",
            "atlas":"アトラス",
            "rokot":"ロコット",
            "delta":"デルタ",
            "vega":"ヴェガ",
            "longmarch":"ロングマーチ",
            "long march":"ロングマーチ",
            "h-iia":"H-2Aロケット",
            "h-iib":"H-2Bロケット",
            "epsilon":"イプシロン",
            "electron":"エレクトロン",
            "saturn":"サターンロケット",
            "kuaizhou":"快舟(かいしゅう)",
            "pslv":"PSLV",
            "zhuque":"朱雀(チューチュエ)",
            "gslv":"GSLV Mark III",
            "antares":"アンタレス",
            "simorgh":"シームルグ",
            "safir":"サフィール",
            "os-m1":"OS-M1",
            "hyperbola":"ハイパーボラ",
            "smart dragon":"捷竜(ジェロン)",
            "smartdragon":"捷竜(ジェロン)",
            "gemini":"ジェミニ",
            "vostok":"ボストーク",
            "voskhod":"ボスホート"
        ]
    
}
