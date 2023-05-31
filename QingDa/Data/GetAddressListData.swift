//
//  GetAddressListData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/6.
//

import Foundation

struct GetAddressListItemData: Codable {
    var addressId: String
    var ifDel: Int
    var address: String
    var personName: String
    var personPhone: String
}


struct GetAddressListData: Codable {
    var list: [GetAddressListItemData]
}
