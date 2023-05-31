//
//  GetReturnMessageData.swift
//  PhoneRepair
//
//  Created by develop on 2022/5/15.
//

import Foundation

struct DeliveryData:Codable {
    var content: String
}

struct GetReturnMessageData:Codable {
    var returnPhone: String
    var expressDeliveryList: [DeliveryData]
}
