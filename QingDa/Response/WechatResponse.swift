//
//  WechatResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/29.
//

import Foundation

class WechatResponse: Codable {
    var access_token: String
    var openid: String
}

class WechatUserResponse: Codable {
    var headimgurl: String
    var nickname: String
}
