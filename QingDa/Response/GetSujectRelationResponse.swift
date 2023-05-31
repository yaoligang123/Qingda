//
//  GetSujectRelationResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/20.
//

import Foundation

class GetSujectRelationVersion: Codable {
    var name: String
}

class GetSujectRelationResponse: Codable {
    var version: [GetSujectRelationVersion]
}
