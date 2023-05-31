//
//  ServiceApplyViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/28.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=98f861d6-90ba-4d66-a57b-b59e17162812&fromEditor=true

import UIKit

class ServiceApplyViewController: UIViewController {
    
    @IBOutlet weak var itemView:ServiceApplyItemView!
    @IBOutlet weak var row1: ServiceApplyRow!
    @IBOutlet weak var row2: ServiceApplyRow!
    var data: ProductOrderData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        self.title = "Aplicativo pós-venda"
        if let data = data, data.list.count > 0 {
            let item = data.list[0]
            itemView.title.text = item.title
            itemView.thumbnail.load(item.thumbnail)
            itemView.norm.text = item.norm
            itemView.amount.text = String(item.amount) + " itens"
        }
        
        row1.tapAction = { [weak self] in
            self?.goRefund(type: .RefundTypeMoney)
        }
        
        row2.tapAction = { [weak self] in
            self?.goRefund(type: .RefundTypeProduct)
        }
    }
    
    func goRefund(type: RefundType) {
        if let data = data {
            Router.push(.Refund(data: data, type: type), from: self)
        }
    }
}
