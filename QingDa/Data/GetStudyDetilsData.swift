//
//  GetStudyDetilsData.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/7.
//

import Foundation

struct StudyDetilsData:Codable {
    var studyId: String
    var title: String
    var thumbnail: String
    var videoUrl: String
    var content: String
    var updateDate: String
}

struct GetStudyDetilsData:Codable {
    var detils: StudyDetilsData
}
