//
//  GetPaperListResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/26.
//

import Foundation

struct GetPaperListItem: Codable {
    var id: String
    var thumbnail: String
    var name: String
    var paperType: String
    var fileUrl: String
    var price: String
    var ifSubscribe: String
}

struct GetPaperPageList: Codable {
    var list: [GetPaperListItem]
}

struct GetPaperListResponse: Codable {
    var testPageList: GetPaperPageList
}
