//
//  MessageListResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/20.
//

import Foundation

class MessageListItem: Codable {
    var id: String
    var message: String
    var state: String
    var category: String
    var createTime: String
}

class MessageListResponse: Codable {
    var records: [MessageListItem]
}
