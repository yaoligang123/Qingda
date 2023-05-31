//
//  CarDetilsData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/8.
//

import Foundation

class CarDetils:Codable {
    var amount: Int
    var thumbnail: String
    var productId: String
    var norm: String
    var state: String
    var title: String
    var newPrice: String
    var carId: String
    var select: Bool = false
}

struct CarDetilsData:Codable {
    var list: [CarDetils]
}
