//
//  GetMyVipOrderDetilsResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/1.
//

import Foundation
import CleanJSON

class GetMyVipOrderDetils: Codable {
    var sysVipId: String
    var surplusAmount: String
    var sysAmount: String
    var sysPackageJson: [SysVipDetilsJson]
    var state: String
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sysVipId = try container.decode(String.self, forKey: .sysVipId)
        surplusAmount = try container.decode(String.self, forKey: .surplusAmount)
        sysAmount = try container.decode(String.self, forKey: .sysAmount)
        state = try container.decode(String.self, forKey: .state)

        let option = try container.decode(String.self, forKey: .sysPackageJson)
         
        let decoder = CleanJSONDecoder()
        if let jsonData = option.data(using: .utf8),
           let option = try? decoder.decode([SysVipDetilsJson].self, from: jsonData){
            sysPackageJson = option
        } else {
            sysPackageJson = []
        }
    }
}

class GetMyVipOrderDetilsObjectList: Codable {
    var thumbnail: String
    var objectName: String
    var objectJson: SysVipDetilsJson
    var objectId: String
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        objectName = try container.decode(String.self, forKey: .objectName)
        objectId = try container.decode(String.self, forKey: .objectId)
        
        let option = try container.decode(String.self, forKey: .objectJson)
        let decoder = CleanJSONDecoder()
        if let jsonData = option.data(using: .utf8),
           let option = try? decoder.decode(SysVipDetilsJson.self, from: jsonData){
            option.thumbnail = thumbnail
            option.name = objectName
            option.objectId = objectId
            objectJson = option
        } else {
            objectJson = SysVipDetilsJson()
        }
    }
}

class GetMyVipOrderDetilsResponse: Codable {
    var orderDetils: GetMyVipOrderDetils
    var objectList: [GetMyVipOrderDetilsObjectList]
}
