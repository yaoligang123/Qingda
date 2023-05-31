//
//  GetOrderDetilsData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/19.
//

import Foundation

struct GetOrderDetils:Codable {
    var orderNumber: String
    var state: String
    var orderPrice: String
    var receiptPerson: String
    var receiptPhone: String
    var receiptAddress: String
    var expressDelivery: String
    var expressDeliveryNumber: String
    var shipDate: String
    var signDate: String
    var payDate: String
}

struct GetOrderDetilsData:Codable {
    var detils: GetOrderDetils
    var list: [ProductOrderItemData]
}
