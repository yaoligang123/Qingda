//
//  SysVipListResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import Foundation
import CleanJSON

class SysVipListResponse: Codable {
    var name: String
    var subtitle: String
    var price: String
    var category: String
    var thumbnail: String
    var vipId: String
    var ifBuy: String
    var appleId: String
    var packageJson: [String]
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        price = try container.decode(String.self, forKey: .price)
        category = try container.decode(String.self, forKey: .category)
        vipId = try container.decode(String.self, forKey: .vipId)
        ifBuy = try container.decode(String.self, forKey: .ifBuy)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        appleId = try container.decode(String.self, forKey: .appleId)
        
        let option = try container.decode(String.self, forKey: .packageJson)
         
        let decoder = CleanJSONDecoder()
        if let jsonData = option.data(using: .utf8),
           let option = try? decoder.decode([String].self, from: jsonData){
            packageJson = option
        } else {
            packageJson = []
        }
    }
}
