//
//  OrderCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/3.
//

import UIKit

class OrderCell: UITableViewCell {
    
    var productOrderData: ProductOrderData?
    var repairOrderData: GetServerOrderListItem?
    weak var vc: UIViewController?
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var orderStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func leftAction() {
        if let productOrderData = productOrderData {
            let state = productOrderData.state
            if state == "1" { //cancel
                updateProductOrder(orderNumber: productOrderData.orderNumber, state: "1")
            } else if state == "3" { //refund
                if let vc = vc {
                    Router.push(.ServiceApply(data: productOrderData), from: vc)
                }
            }
        } else if let repairOrderData = repairOrderData {
            let state = repairOrderData.state
            if state == "2" || state == "3" {
                updateRepairOrder(orderNumber: repairOrderData.orderNumber, state: "1")
            }
        }
    }
    
    @IBAction func rightAction() {
        if let productOrderData = productOrderData {
            let state = productOrderData.state
            if state == "1" { //pay
                if let vc = vc {
                    let order = GetPayProductData(orderNumber: productOrderData.orderNumber,
                                                  orderprice: productOrderData.orderPrice)
                    Router.push(.Bank(order: order, category: "1"), from: vc)
                }
            } else if state == "2" { //refund
                if let vc = vc {
                    Router.push(.ServiceApply(data: productOrderData), from: vc)
                }
            } else if state == "3" { //confirm
                updateProductOrder(orderNumber: productOrderData.orderNumber, state: "2")
            } else if state == "5" {
                if let vc = vc {
                    Router.push(.Refund(data: productOrderData, type: .RefundTypeMoney), from: vc)
                }
            }
        } else if let _ = repairOrderData {
            if let store = gStore, let vc = vc {
                Router.push(.Map(data: store),
                            from: vc)
            }
        }
    }
    
    func updateProductOrder(orderNumber: String, state: String) {
        vc?.startLoading()
        NetWork.request(.productOrderUpdate,
                        modelType: NoneResponseData.self,
                        parameters: ["orderNumber":orderNumber, "state" : state]) { result, model, msg in
            if let _ = model {
                NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
            }
            self.vc?.stopLoading()
        }
    }
    
    func updateRepairOrder(orderNumber: String, state: String) {
        vc?.startLoading()
        NetWork.request(.serverOrderUpdate,
                        modelType: NoneResponseData.self,
                        parameters: ["orderNumber":orderNumber, "state" : state]) { result, model, msg in
            if let _ = model {
                NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
            }
            self.vc?.stopLoading()
        }
    }
    
    func config(_ data: ProductOrderData) {
        repairOrderData = nil
        productOrderData = data
        order.text = "Número：" + data.orderNumber
        state.text = stringFromProductState(data.state)
        orderStack.removeAll()
        for item in data.list {
            let row = ItemRow()
            row.title.text = item.title
            row.reserve.text = item.norm
            row.price.text = kUnit + item.price
            row.num.isHidden = false
            row.num.text = String(item.amount) + " itens"
            row.thumbnail.load(item.thumbnail)
            row.translatesAutoresizingMaskIntoConstraints = false
            row.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            orderStack.addArrangedSubview(row)
        }
        
        leftBtn.isHidden = false
        rightBtn.isHidden = false
        bottom.isHidden = false
        rightBtn.backgroundColor = .white
        phoneBtn.isHidden = true
        
        let state = data.state
        if state == "1" {
            leftBtn.setTitle("Cancelar", for: .normal)
            leftBtn.layer.borderWidth = 1
            leftBtn.layer.borderColor = HEX(kSubColor2).cgColor
            leftBtn.setTitleColor(HEX(kSubColor2), for: .normal)
            rightBtn.setTitle("Fazer compra", for: .normal)
            rightBtn.layer.borderColor = HEX(kMainColor1).cgColor
            rightBtn.setTitleColor(HEX(kMainColor1), for: .normal)
        } else if state == "2" {
            leftBtn.isHidden = true
            rightBtn.setTitle("Venda", for: .normal)
            rightBtn.layer.borderColor = HEX(kMainColor1).cgColor
            rightBtn.setTitleColor(HEX(kMainColor1), for: .normal)
        } else if state == "3" {
            leftBtn.setTitle("Venda", for: .normal)
            leftBtn.layer.borderWidth = 1
            leftBtn.layer.borderColor = HEX(kMainColor1).cgColor
            leftBtn.setTitleColor(HEX(kMainColor1), for: .normal)
            rightBtn.setTitle("Confirmar", for: .normal)
            rightBtn.layer.borderColor = HEX(kMainColor1).cgColor
            rightBtn.backgroundColor = HEX(kMainColor1)
            rightBtn.setTitleColor(.white, for: .normal)
        } else if state == "4" {
            bottom.isHidden = true
        } else if state == "5" {
            leftBtn.isHidden = true
            rightBtn.setTitle(getRefundState(data.returnService), for: .normal)
            rightBtn.layer.borderColor = HEX(kSubColor2).cgColor
            rightBtn.setTitleColor(HEX(kSubColor2), for: .normal)
        }
    }
    
    func config(_ data: GetServerOrderListItem) {
        productOrderData = nil
        repairOrderData = data
        order.text = "Número：" + data.orderNumber
        state.text = stringFromRepairState(data.state)
        orderStack.removeAll()
        let row = ItemRow()
        row.title.text = data.phoneModel
        row.reserve.text = data.optionas + data.optionas + data.optionas + data.optionas
        row.price.text = kUnit + data.price
        row.translatesAutoresizingMaskIntoConstraints = false
        row.heightAnchor.constraint(equalToConstant: 80).isActive = true
        row.thumbnail.backgroundColor = HEX(kMainColor1)
        row.thumbnail.layer.cornerRadius = 8
        row.thumbnail.layer.masksToBounds = true
        row.imageTitle.text = data.category == "1" ? "serviço\nna loja" : "serviço\ndelivery"
        orderStack.addArrangedSubview(row)
        
        leftBtn.isHidden = true
        rightBtn.isHidden = true
        phoneBtn.isHidden = false
        
        let state = data.state
        if state == "2" || state == "3" {
            leftBtn.isHidden = false
            leftBtn.layer.borderWidth = 1
            leftBtn.layer.borderColor = HEX(kSubColor2).cgColor
            leftBtn.setTitleColor(HEX(kSubColor2), for: .normal)
            leftBtn.setTitle("Cancelar", for: .normal)
        }
        
        if data.category == "1", let _ = gStore {
            rightBtn.isHidden = false
            rightBtn.setTitle("Traçar rota ate a loja", for: .normal)
            rightBtn.layer.borderColor = HEX(kMainColor1).cgColor
            rightBtn.backgroundColor = HEX(kMainColor1)
            rightBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    func getRefundState(_ returnService:Double) -> String {
        if returnService == 1 || returnService == 2 || returnService == 2.3 {
            return "Pós-venda em andamento"
        } else if returnService == 2.1 {
            return "Pós-venda em andamento"
        }
        
        return "Concluído"
    }
    
    @IBAction func goTel() {
        tel()
    }
}
