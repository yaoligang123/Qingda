//
//  GetCourseDetilsTwoResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import Foundation

struct Coupon: Codable {
    var discountAmount: Double
    var couponId: String
}

struct GetCourseDetilsTwoResponse: Codable {
    var isBookAdded: Int
    var ifVipOrder: Int
    var ifBuy: Int
    var vipOrderCount: String
    var coupon: Coupon?
}
