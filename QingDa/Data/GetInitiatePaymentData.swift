//
//  GetInitiatePaymentData.swift
//  PhoneRepair
//
//  Created by develop on 2022/4/24.
//

import Foundation

struct SaleData:Codable {
    var payment: PaymentData
}

struct PaymentData:Codable {
    var amount: Int64
}

struct GetInitiatePaymentData:Codable {
    var callbackUrl: String
    var sale: SaleData
}
