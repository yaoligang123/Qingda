//
//  GetMyCoursePageResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import Foundation
import CleanJSON

struct GetMyCoursePageJson: Codable {
    var suject: String
    var grade: String
    var semester: String
    var edition: String
    var years: String
}
class GetMyCoursePageItem: Codable {
    var objectName:String
    var thumbnail:String
    var objectJson: GetMyCoursePageJson
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectName = try container.decode(String.self, forKey: .objectName)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)

        let option = try container.decode(String.self, forKey: .objectJson)
         
        let decoder = CleanJSONDecoder()
        if let jsonData = option.data(using: .utf8),
           let option = try? decoder.decode(GetMyCoursePageJson.self, from: jsonData){
            objectJson = option
        } else {
            objectJson = GetMyCoursePageJson(suject: "", grade: "", semester: "", edition: "", years: "")
        }
    }
}

class GetMyCoursePageResponse: Codable {
    var records:[GetMyCoursePageItem]
}
