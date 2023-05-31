//
//  GetIndexMessageOneData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/6.
//

import Foundation

struct BannerListData: Codable {
    var bannerId: String
    var bannerUrl: String
}

struct StoreData: Codable {
    var storeId: String
    var name: String
    var address: String
    var latitude: String
    var longitude: String
    var businessHours: String
    var thumbnail: String
}

struct GetIndexMessageOneData: Codable {
    var bannerList: [BannerListData]
    var store: StoreData
}
