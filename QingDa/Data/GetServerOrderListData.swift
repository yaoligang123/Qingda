//
//  GetServerOrderListData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/19.
//

import Foundation

struct GetServerOrderListItem:Codable {
    var orderNumber: String
    var state: String
    var price: String
    var phoneModel: String
    var optionas: String
    var category: String
}

struct GetServerOrderListData:Codable {
    var list: [GetServerOrderListItem]
}
