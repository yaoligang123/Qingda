//
//  GetUserMessageResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/8.
//

import Foundation

struct GetUserMessageUser: Codable {
    var nickName: String
    var province: String
    var city: String
    var grade: String
    var headimage: String
    var phone: String
    var school: String
    var studyTimeCount: Int
}

struct VipOrder: Codable {
    var sysName: String
    var sysAmount: String
    var surplusAmount: String
    var orderNumber: String
}

struct GetUserMessageResponse: Codable {
    var user: GetUserMessageUser
    var vipOrder: VipOrder?
}
