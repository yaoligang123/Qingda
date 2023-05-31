//
//  GetRecommendResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/30.
//

import Foundation

struct GetRecommendResponse: Codable {
    var id: String
    var courseName: String
    var thumbnail: String
    var category: String
    var courseId: String
    var suject: String
    var grade: String
    var semester: String
}
