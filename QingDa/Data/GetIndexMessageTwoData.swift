//
//  GetIndexMessageTwoData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/6.
//

import Foundation

struct StudyData: Codable {
    var studyId: String
    var title: String
    var thumbnail: String
    var updateDate: String
}

struct GetIndexMessageTwoData: Codable {
    var list: [StudyData]
}
