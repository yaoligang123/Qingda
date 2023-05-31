//
//  GetPlayInfoWithOptionsResponse.swift
//  PhoneRepair
//
//  Created by develop on 2023/1/7.
//

import Foundation

class PlayInfo : Codable {
    var playURL: String
}

class PlayInfoList : Codable {
    var playInfo: [PlayInfo]
}

class GetPlayInfoWithOptionsResponse: Codable {
    var playInfoList: PlayInfoList
}
