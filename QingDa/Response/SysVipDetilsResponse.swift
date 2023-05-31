//
//  SysVipDetilsResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import Foundation
import CleanJSON

class SysVipDetilsJson: Codable {
    var objectId:String = ""
    var thumbnail:String = ""
    var name:String = ""
    var suject:String = ""
    var grade:String = ""
    var semester:String = ""
    var years:String = ""
    var edition:String = ""
    var select:Bool = false
    var category:String = ""
    var ifHave:String = ""
}

class SysVipDetilsResponse: Codable {
    var name:String
    var subtitle:String
    var price:String
    var dateCount:String
    var amount:String
    var equities:String
    var buyInform:String
    var useInform:String
    var vipId:String
    var category:String
    var thumbnail:String
    var packageJson: [SysVipDetilsJson]
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        price = try container.decode(String.self, forKey: .price)
        dateCount = try container.decode(String.self, forKey: .dateCount)
        amount = try container.decode(String.self, forKey: .amount)
        equities = try container.decode(String.self, forKey: .equities)
        buyInform = try container.decode(String.self, forKey: .buyInform)
        useInform = try container.decode(String.self, forKey: .useInform)
        vipId = try container.decode(String.self, forKey: .vipId)
        category = try container.decode(String.self, forKey: .category)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)

        let option = try container.decode(String.self, forKey: .packageJson)
         
        let decoder = CleanJSONDecoder()
        if let jsonData = option.data(using: .utf8),
           let option = try? decoder.decode([SysVipDetilsJson].self, from: jsonData){
            packageJson = option
        } else {
            packageJson = []
        }
    }
}

class SysVipDetilsNowResponse: Codable {
    var detils: SysVipDetilsResponse
    var ifBuy: Int
    var sysAmount: Int
    var surplusAmount: Int
}
