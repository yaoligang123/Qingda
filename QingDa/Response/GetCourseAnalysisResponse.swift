//
//  GetCourseAnalysisResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/27.
//

import Foundation

struct GetCourseAnalysisItem: Codable {
    var fileUrl: String
}

struct GetCourseAnalysisResponse: Codable {
    var analysisList: [GetCourseAnalysisItem]
}
