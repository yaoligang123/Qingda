//
//  GetRepairModelDetilsData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/6.
//

import Foundation
import CleanJSON

struct GetRepairModelOptionData: Codable {
    var optiona: String
    var price: String
}
    
class GetRepairModelDetilsData: Codable {
    var modelId: String
    var brandId: String
    var title: String
    var row: Int = -1
    var optionJson: [GetRepairModelOptionData]
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        modelId = try container.decode(String.self, forKey: .modelId)
        brandId = try container.decode(String.self, forKey: .brandId)
        title = try container.decode(String.self, forKey: .title)
        let option = try container.decode(String.self, forKey: .optionJson)
         
        let decoder = CleanJSONDecoder()
        if let jsonData = option.data(using: .utf8),
           let option = try? decoder.decode([GetRepairModelOptionData].self, from: jsonData){
            optionJson = option
        } else {
            optionJson = []
        }
    }
}
