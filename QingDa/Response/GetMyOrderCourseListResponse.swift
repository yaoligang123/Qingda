//
//  GetMyOrderCourseListResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import Foundation
import CleanJSON

class GetMyOrderCourseListItem: Codable {
    var orderNumber:String
    var thumbnail:String
    var objectName:String
    var price:String
    var source:String
    var createTime:String
    var objectJson:GetMyCourseJson
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectName = try container.decode(String.self, forKey: .objectName)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        orderNumber = try container.decode(String.self, forKey: .orderNumber)
        price = try container.decode(String.self, forKey: .price)
        source = try container.decode(String.self, forKey: .source)
        createTime = try container.decode(String.self, forKey: .createTime)

        let option = try container.decode(String.self, forKey: .objectJson)
         
        let decoder = CleanJSONDecoder()
        if let jsonData = option.data(using: .utf8),
           let option = try? decoder.decode(GetMyCourseJson.self, from: jsonData){
            objectJson = option
        } else {
            objectJson = GetMyCourseJson(suject: "", grade: "", semester: "", edition: "", years: "")
        }
    }
}

class GetMyOrderCourseListResponse: Codable {
    var records: [GetMyOrderCourseListItem]
}
