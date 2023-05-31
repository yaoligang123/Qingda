//
//  GetProductByTypeResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/31.
//

import Foundation

struct GetProductByTypeResponse: Codable {
    var records: [GetProductByTypeRecordResponse]
}

struct GetProductByTypeRecordResponse: Codable {
    var thumbnail: String
    var productId: String
    var price: Double
    var title: String
}
