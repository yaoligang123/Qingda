//
//  ConfirmItemCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/9.
//

import UIKit

class ConfirmItemCell: UITableViewCell {
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var info: UIStackView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ data:[CarDetils]) {
        total.text = String(data.reduce(0, { partialResult, item in
            partialResult + item.amount
        })) + kAmountUnit
        stack.removeAll()
        for item in data {
            let row = ConfirmItemRow()
            row.config(item)
            stack.addArrangedSubview(row)
        }
        line.backgroundColor = .white
    }
    
    func config(_ data:GetProductDetilsData) {
        total.text = "1" + kAmountUnit
        stack.removeAll()
        let row = ConfirmItemRow()
        row.config(data)
        stack.addArrangedSubview(row)
        line.backgroundColor = .white
    }
    
    func config(_ data:GetOrderDetilsData) {
        total.text = String(data.list.reduce(0, { partialResult, item in
            partialResult + item.amount
        })) + kAmountUnit
        stack.removeAll()
        for item in data.list {
            let row = ConfirmItemRow()
            row.config(item)
            stack.addArrangedSubview(row)
        }
        top.constant = 16
        bottom.constant = 16
        info.removeAll()
        
        addRow(title: "Número", value: data.detils.orderNumber)
        addRow(title: "Quantidade", value: kUnit + data.detils.orderPrice)
        addRow(title: "Data de pagamento", value: data.detils.payDate)
        addRow(title: "Data de envio", value: data.detils.shipDate)
        addRow(title: "Data da assinatura", value: data.detils.signDate)
    }
    
    func addRow(title:String, value:String) {
        if value.isEmpty { return }
        let view = TitleValueRow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true

        view.title.text = title
        view.textField.text = value
        
        view.title.textColor = HEX(kSubColor2)
        view.textField.isUserInteractionEnabled = false
        view.textField.textColor = HEX(kMainColor2)
        info.addArrangedSubview(view)
    }
}
