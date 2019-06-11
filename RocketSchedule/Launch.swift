//
//  TestLaunch.swift
//  RocketSchedule
//
//  Created by Hidemasa Kobayashi on 2019/01/15.
//  Copyright © 2019 zilch. All rights reserved.
//

import Foundation

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
        var vidURLs: [String]?
        var probability: Int?
        var changed: String?
        var lsp: String?
        var location: [String]?
        
//        struct Location: Codable{
//
//            var id: Int
//            var name: String
//            var description: String
//            var type: String
//            var wikiURL: String
//            var typeName: String
//            var agencies: [Int]
//            var tbdtime: Int
//            var vidURLs: [String]?
//            var probability: Int?
//            var changed: String?
//            var lsp: String?
//            var location: [String]?
//
//
//
//
//        }


    }
    
    
}

//extension TestLaunch: Decodable {
//
//    init(from decoder: Decoder) throws {
//        self.contents = []
//        let root = try decoder.container(keyedBy: RootKeys.self)
//        var items = try root.nestedUnkeyedContainer(forKey: .launches)
//        
//        while !items.isAtEnd {
//            let container = try items.nestedContainer(keyedBy: LaunchesKeys.self)
//            var content = Content()
//            do{
//                content.id = try container.decode(Int.self, forKey: .id)
//            }catch{
//                print(error)
//            }
//            do{
//                content.name = try container.decode(String.self, forKey: .name)
//            }catch{
//                print(error)
//            }
//            do{
//                content.windowstart = try container.decode(String.self, forKey: .windowstart)
//            }catch{
//                print(error)
//            }
//            do{
//                content.windowend = try container.decode(String.self, forKey: .windowend)
//            }catch{
//                print(error)
//            }
//            do{
//                content.net = try container.decode(String.self, forKey: .net)
//            }catch{
//                print(error)
//            }
//            do{
//                content.status = try container.decode(Int.self, forKey: .status)
//            }catch{
//                print(error)
//            }
//            do{
//                content.tbdtime = try container.decode(Int.self, forKey: .tbdtime)
//            }catch{
//                print(error)
//            }
//            do{
//                content.vidURLs = try container.decode(String.self, forKey: .vidURLs)
//            }catch{
//                print(error)
//            }
//            do{
//                content.vidURL = try container.decode(String.self, forKey: .vidURL)
//            }catch{
//                print(error)
//            }
//            do{
//                content.tbddate = try container.decode(Int.self, forKey: .tbddate)
//            }catch{
//                print(error)
//            }
//            do{
//                content.probability = try container.decode(Int.self, forKey: .probability)
//            }catch{
//                print(error)
//            }
//            do{
//                content.changed = try container.decode(String.self, forKey: .changed)
//            }catch{
//                print(error)
//            }
//            do{
//                content.lsp = try container.decode(Int.self, forKey: .lsp)
//            }catch{
//                print(error)
//            }
//            do{
//                self.contents?.append(content)
//            }catch{
//                print(error)
//            }
//        }
//        total = try root.decode(Int.self, forKey: .total)
//    }
//
//}

