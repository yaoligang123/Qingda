//
//  GetProductDetilsData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/8.
//

import Foundation

struct ProductData:Codable {
    var productId: String
    var title: String
    var thumbnail: String
    var banners: String
    var content: String
}

struct SkuData:Codable {
    var skuId: String
    var norm: String
    var reserve: String
    var newPrice: String
}

struct GetProductDetilsData:Codable {
    var product: ProductData
    var skuList: [SkuData]
}
