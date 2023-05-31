//
//  GetMyVipOrderListResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import Foundation
import CleanJSON

class GetMyVipOrderListItem: Codable {
    var sysName:String
    var sysSubtitle:String
    var price:String
    var expirationTime:String
    var surplusAmount:String
    var sysAmount:String
    var couponId:String
    var objectId:String
    var category:String
    var orderNumber:String
    var sysThumbnail:String
    var sysPackageJson:[String]
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sysName = try container.decode(String.self, forKey: .sysName)
        sysSubtitle = try container.decode(String.self, forKey: .sysSubtitle)
        price = try container.decode(String.self, forKey: .price)
        expirationTime = try container.decode(String.self, forKey: .expirationTime)
        surplusAmount = try container.decode(String.self, forKey: .surplusAmount)
        sysAmount = try container.decode(String.self, forKey: .sysAmount)
        couponId = try container.decode(String.self, forKey: .couponId)
        objectId = try container.decode(String.self, forKey: .objectId)
        category = try container.decode(String.self, forKey: .category)
        orderNumber = try container.decode(String.self, forKey: .orderNumber)
        sysThumbnail = try container.decode(String.self, forKey: .sysThumbnail)

        let option = try container.decode(String.self, forKey: .sysPackageJson)
         
        let decoder = CleanJSONDecoder()
        if let jsonData = option.data(using: .utf8),
           let option = try? decoder.decode([String].self, from: jsonData){
            sysPackageJson = option
        } else {
            sysPackageJson = []
        }
    }
}

struct GetMyVipOrderListResponse: Codable {
    var records:[GetMyVipOrderListItem]
}

