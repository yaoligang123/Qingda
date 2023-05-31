//
//  GetBannerResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/29.
//

//获取轮播图

import Foundation

struct GetBannerListResponse: Codable {
    var bannerUrl: String
    var ifJump: Int
    var objectId: String
}

