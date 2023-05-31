//
//  GetSearchCourseResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/19.
//

import Foundation

struct GetSearchCourseItem: Codable {
    var name: String
    var thumbnail: String
    var courseId: String
    var category: String
    var semester: String
    var grade: String
    var suject: String
    var edition: String
    var years: String
    var ifBuy: Int
}

struct GetSearchCourseResponse: Codable {
    var list: [GetSearchCourseItem]
}
