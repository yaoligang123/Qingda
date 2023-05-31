//
//  SubmitDetailCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/27.
//

import UIKit

class SubmitDetailCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var row1: SubmitShowView!
    @IBOutlet weak var row2: SubmitShowView!
    @IBOutlet weak var row3: SubmitShowView!
    
    func config(items: [GetRepairModelDetilsData], data: GetRepairPhoneData, total:String) {
        
        row1.title.text = "Conserto de celular"
        row1.value.text = data.name
        row2.title.text = "Orçamento"
        row2.value.text = kUnit + total
        row3.title.text = "Defeito"
        row3.value.text = ""
        
        stackView.removeAll()
        
        for item in items {
            let view = SubmitShowView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 20).isActive = true
            view.line.isHidden = false
            let data = item.optionJson[item.row]
            view.title.text = data.optiona
            view.value.text = kUnit + data.price
            
            view.title.textColor = HEX(kMainColor3)
            view.value.textColor = HEX(kMainColor3)
            stackView.addArrangedSubview(view)
        }
    }
    
    func config(data: GetServerOrderDetilsData) {
        row1.title.text = "Conserto de celular"
        row1.value.text = data.detils.phoneModel
        row2.title.text = "Orçamento"
        row2.value.text = kUnit + data.detils.price
        row3.title.text = "Defeito"
        row3.value.text = ""
        
        stackView.removeAll()
        for item in data.list {
            let view = SubmitShowView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 20).isActive = true
            view.line.isHidden = false
            view.title.text = item.optiona
            view.value.text = kUnit + item.price
            
            view.title.textColor = HEX(kMainColor3)
            view.value.textColor = HEX(kMainColor3)
            stackView.addArrangedSubview(view)
        }
    }
}
