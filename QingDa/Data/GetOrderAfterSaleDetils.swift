//
//  GetOrderAfterSaleDetils.swift
//  PhoneRepair
//
//  Created by develop on 2022/4/4.
//

import Foundation

struct GetOrderAfterSaleData:Codable {
    var orderNumber: String
    var depict: String
    var image: String
    var productState: String
    var returnService: Double
    var returnType: String
    var returnMoney: String
    
    var returnName: String
    var returnPhone: String
    var returnAddress: String
    
    var expressDelivery: String
    var expressDeliveryNumber: String
}

struct GetOrderAfterSaleDetils:Codable {
    var detils: GetOrderAfterSaleData
}
