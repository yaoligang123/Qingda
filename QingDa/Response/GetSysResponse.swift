//
//  GetSysResponse.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/30.
//

import Foundation

struct GetSysResponse: Codable {
    var content: String
    var children: [GetSysResponse]
}
