//
//  GetMyDownResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import Foundation

class GetMyDownItem: Codable {
    var category:String
    var downType:String
    var createTime:String
    var name:String
    var amount:String
}

class GetMyDownResponse: Codable {
    var records: [GetMyDownItem]
}
