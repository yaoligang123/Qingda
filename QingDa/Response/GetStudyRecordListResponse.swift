//
//  GetStudyRecordListResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/26.
//

import Foundation

struct GetStudyRecordListItem: Codable {
    var name: String
    var thumbnail: String
    var semester: String
    var grade: String
    var suject: String
    var edition: String
    var years: String
    var studyName: String
    var category: String
    var courseId: String
    var directoryName: String
}

struct GetStudyRecordListResponse: Codable {
    var records: [GetStudyRecordListItem]
}
