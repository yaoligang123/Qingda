//
//  GetCourseDetilsOneResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/24.
//

import Foundation

class GetCourseDetilsOneResponse: Codable {
    var pointCount: String
    var updatePointCount: String
    var studyPointId: String
    var detils: GetCourseDetilsOneDetils
    var list: [GetCourseDetilsOneList]
}

class GetCourseDetilsOneDetils: Codable {
    var studyCount: String
    var banner: String
    var thumbnail: String
    var name: String
    var subscribeCount: String
    var price: Double
    var content: String
    var salesFalse: String
    
    var suject: String
    var grade: String
    var semester: String
    var edition: String
    var years: String
}

class GetCourseDetilsItem: Codable {
    var id: String
    var directoryName: String
    var videoUrl: String
    var category: String
    var questionId: String
    var name: String
    var studyBili: String
    var directoryId: String
    var ifStudy: String
    var videoId: String
    var aliyunVideoId: String
}

class GetCourseDetilsOneList: Codable {
    var id: String
    var name: String
    var parentId: String
    var children: [GetCourseDetilsOneList]
    var list: [GetCourseDetilsItem]
}

