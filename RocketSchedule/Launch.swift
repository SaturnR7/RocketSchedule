//
//  TestLaunch.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/15.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

// Using URL: https://launchlibrary.net/1.4/launch?mode=verbose&next=100

struct Launch: Codable {
    
    var launches: [Content]
    var total: Int
    var offset: Int
    var count: Int
    
    struct Content: Codable {
        var id: Int
        var name: String
        var windowstart: String
        var windowend: String
        var net: String
        var status: Int
        var tbddate: Int
        var tbdtime: Int
        var vidURLs: [String]
        var probability: Int?
        var changed: String?
        var location: Location
        var rocket: RocketContent
        var missions: [MissionContent]?
        var lsp: LspContent?
        
        struct Location: Codable{
            var pads: [PadsContent]
            var id: Int
            var name: String
            var wikiURL: String?
            
            struct PadsContent: Codable{
                var agencies: [AgenciesContent]?
                
                struct AgenciesContent: Codable{
                    var id: Int
                    var name: String
                    var abbrev: String
                    var countryCode: String
                    var type: Int
                    var infoURL: String?
                    var wikiURL: String?
                    var changed: String?
                    var infoURLs: [String]?
                    
                }
            }
        }

        struct RocketContent: Codable{
            var id: Int
            var name: String
            var agencies: [AgenciesContent]?
            var wikiURL: String?
            var infoURL: String?
            var changed: String?
            var infoURLs: [String]?
            var imageSizes: [Int]?
            var imageURL: String?
            
            struct AgenciesContent: Codable{
                var id: Int
                var name: String
                var abbrev: String
                var countryCode: String
                var type: Int
                var infoURL: String?
                var wikiURL: String?
                var changed: String?
                var infoURLs: [String]?
                
            }
        }

        struct MissionContent: Codable{
            var id: Int
            var name: String
            var description: String
            var type: Int
            var wikiURL: String
            var typeName: String
            var agencies: [AgenciesContent]?
            var payloads: [PayloadsContent]?
            
            struct AgenciesContent: Codable{
                var id: Int
                var name: String
                var abbrev: String
                var countryCode: String
                var type: Int
                var infoURL: String?
                var wikiURL: String?
                var changed: String?
                var infoURLs: [String]?
                
            }
            
            struct PayloadsContent: Codable {
                var id: Int
                var name: String
            }
        }

        struct LspContent: Codable{
            var id: Int
            var name: String
            var abbrev: String
            var countryCode: String
            var type: Int
            var infoURL: String?
            var wikiURL: String?
            var changed: String?
            var infoURLs: [String]?

        }
    }
}
