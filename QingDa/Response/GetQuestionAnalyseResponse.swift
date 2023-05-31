//
//  GetQuestionAnalyseResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/3.
//

import Foundation

struct GetQuestionAnalyseQuestion: Codable {
    var id: String
    var videoUrl: String
    var correctAnswer: String
    var parse: String
}

class GetQuestionAnalyseResponse: Codable {
    var ifErrorBook: Int
    var question: GetQuestionAnalyseQuestion
}
