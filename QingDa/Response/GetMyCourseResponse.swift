//
//  GetMyCourseResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/28.
//

import Foundation
import CleanJSON

struct GetMyCourseJson: Codable {
    var suject: String
    var grade: String
    var semester: String
    var edition: String
    var years: String
}

class GetMyCourseItem: Codable {
    var objectName: String
    var thumbnail: String
    var objectId: String
    var category: String
    
    var objectJson: GetMyCourseJson
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectName = try container.decode(String.self, forKey: .objectName)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        objectId = try container.decode(String.self, forKey: .objectId)
        category = try container.decode(String.self, forKey: .category)

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

struct GetMyCourseResponse: Codable {
    var records: [GetMyCourseItem]
}
