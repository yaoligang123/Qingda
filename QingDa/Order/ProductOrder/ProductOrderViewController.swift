//
//  ProductOrderViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/18.
//
//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=7a44c118-2c78-45af-b6a5-835b952ceb11&fromEditor=true

import UIKit

class ProductOrderViewController: UIViewController {
    
    var data:ProductOrderData?
    var model:GetOrderDetilsData?
    
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var notice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getOrderDetils()
    }

    func setUI() {
        self.title = "Detalhe do pedido"
        
        tableView.register(UINib(nibName: "ConfirmItemCell", bundle: nil), forCellReuseIdentifier: "ConfirmItemCell")
        tableView.register(UINib(nibName: "ProductOrderAddressCell", bundle: nil), forCellReuseIdentifier: "ProductOrderAddressCell")
        
        leftBtn.layer.borderWidth = 1
        leftBtn.layer.borderColor = HEX(kMainColor1).cgColor
    }
    
    func getOrderDetils() {
        
        guard let orderNumber = data?.orderNumber else { return }
        startLoading(transparent: false)
        NetWork.request(.getOrderDetils,
                        modelType: GetOrderDetilsData.self,
                        parameters: ["orderNumber":orderNumber]) { result, model, msg in
            if let model = model {
                self.model = model
                self.tableView.reloadData()
                self.config()
                self.stopLoading()
            } else {
                self.showError()
            }
        }
    }
    
    func config() {
        if let model = model {
            let state = model.detils.state
            price.text = kUnit + model.detils.orderPrice
            
            bottom.isHidden = false
            notice.isHidden = true
            
            let bottomH = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            if state == "1" {
                leftBtn.setTitle("Cancelar", for: .normal)
                rightBtn.setTitle("Fazer compra", for: .normal)
                bottomConstraint.constant = bottomH + 70
            } else if state == "2" {
                leftBtn.setTitle("Pós-venda", for: .normal)
                rightBtn.isHidden = true
                bottomConstraint.constant = bottomH + 70
            } else if state == "3" {
                notice.isHidden = false
                leftBtn.setTitle("Pós-venda", for: .normal)
                rightBtn.setTitle("Sinal", for: .normal)
                bottomConstraint.constant = bottomH + 70 + 27
            } else {
                bottom.isHidden = true
                bottomConstraint.constant = 10
            }
        }
    }
    
    @IBAction func leftBtnTouch() {
        if let model = model {
            let state = model.detils.state
            if state == "1" {
                startLoading()
                NetWork.request(.productOrderUpdate,
                                modelType: NoneResponseData.self,
                                parameters: ["orderNumber":model.detils.orderNumber, "state" : "1"]) { result, model, msg in
                    if let _ = model {
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
                    }
                    self.stopLoading()
                }
            } else if state == "2" || state == "3", let data = data {
                Router.push(.ServiceApply(data: data), from: self)
            }
        }
    }
    
    @IBAction func rightBtnTouch() {
        if let model = model {
            let state = model.detils.state
            if state == "1" {
                let order = GetPayProductData(orderNumber: model.detils.orderNumber,
                                              orderprice: model.detils.orderPrice)
                Router.push(.Bank(order: order, category: "1"), from: self)
            } else if state == "3" {
                startLoading()
                NetWork.request(.productOrderUpdate,
                                modelType: NoneResponseData.self,
                                parameters: ["orderNumber":model.detils.orderNumber, "state" : "2"]) { result, model, msg in
                    if let _ = model {
                        self.getOrderDetils()
                        NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
                    }
                    self.stopLoading()
                }
            }
        }
    }
}


extension ProductOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
}

extension ProductOrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let model = model {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductOrderAddressCell", for: indexPath) as! ProductOrderAddressCell
                cell.config(model.detils)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmItemCell", for: indexPath) as! ConfirmItemCell
                cell.config(model)
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
