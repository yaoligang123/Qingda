//
//  GetErrorBookSujectCountResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/26.
//

import Foundation

class GetErrorBookSujectCountResponse: Codable {
    var suject: String
    var image: String
    var sujectCount: String
    
    init(suject: String, image: String, sujectCount: String) {
        self.suject = suject
        self.image = image
        self.sujectCount = sujectCount
    }
}
