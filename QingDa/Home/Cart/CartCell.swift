//
//  CartCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/1.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var select: UIButton!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var itemRow: ItemRow!
    var data:CarDetils!
    
    func config(_ data:CarDetils) {
        self.data = data
        itemRow.title.text = data.title
        itemRow.thumbnail.load(data.thumbnail)
        itemRow.reserve.text = data.norm
        itemRow.price.text = kUnit + data.newPrice
        count.text = String(data.amount)
        select.isSelected = data.select
        if data.state != "1" {
            select.isEnabled = false
        }
    }
    
    @IBAction func add() {
        data.amount = data.amount + 1
        count.text = String(data.amount)
        updateCarAmount()
    }
    
    @IBAction func sub() {
        if data.amount > 1 {
            data.amount = data.amount - 1
            count.text = String(data.amount)
        }
        updateCarAmount()
    }
    
    func updateCarAmount() {
        NetWork.request(.updateCarAmount,
                        modelType: NoneResponseData.self,
                        parameters: ["carId": data.carId, "amount":String(data.amount)]) { result, model, msg in
        }
    }
}
