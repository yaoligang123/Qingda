//
//  ConfirmItemRow.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/9.
//

import UIKit

class ConfirmItemRow: CommonView {
    
    @IBOutlet weak var itemRow: ItemRow!
    
    func config(_ data : CarDetils) {
        itemRow.title.text = data.title
        itemRow.reserve.text = data.norm
        itemRow.price.text = kUnit + data.newPrice
        itemRow.thumbnail.load(data.thumbnail)
        itemRow.num.isHidden = false
        itemRow.num.text = String(data.amount) + kAmountUnit
    }
    
    func config(_ data : ProductOrderItemData) {
        itemRow.title.text = data.title
        itemRow.reserve.text = data.norm
        itemRow.price.text = kUnit + data.price
        itemRow.thumbnail.load(data.thumbnail)
        itemRow.num.isHidden = false
        itemRow.num.text = String(data.amount) + kAmountUnit
    }
    
    func config(_ data : GetProductDetilsData) {
        itemRow.title.text = data.product.title
        itemRow.reserve.text = data.skuList[0].reserve
        itemRow.price.text = kUnit + data.skuList[0].newPrice
        itemRow.thumbnail.load(data.product.thumbnail)
        itemRow.num.isHidden = false
        itemRow.num.text = "1" + kAmountUnit
    }
}
