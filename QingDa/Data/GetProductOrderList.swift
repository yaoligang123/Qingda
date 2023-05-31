//
//  GetProductOrderList.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/18.
//

import Foundation

struct ProductOrderItemData:Codable {
    var productId: String
    var thumbnail: String
    var title: String
    var norm: String
    var price: String
    var amount: Int
}

struct ProductOrderData:Codable {
    var orderNumber: String
    var state: String
    var orderPrice: String
    var returnService: Double
    var list: [ProductOrderItemData]
}

struct GetProductOrderList:Codable {
    var list: [ProductOrderData]
}
