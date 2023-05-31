//
//  GetServerOrderDetilsData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/19.
//

import Foundation

struct GetServerOrderData:Codable {
    var category: String
    var lockScreenPassword: String
    var reservationDate: String
    var reservationTime: String
    var phoneModel: String
    var price: String
    var personName: String
    var personPhone: String
    var address: String
    var state: String
}

struct GetServerOrderDetilsListItem:Codable {
    var optiona: String
    var price: String
}

struct GetServerOrderDetilsData:Codable {
    var detils: GetServerOrderData
    var store: StoreData
    var list: [GetServerOrderDetilsListItem]
}
