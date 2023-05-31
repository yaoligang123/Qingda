//
//  OrderConfirmViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/9.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=7a44c118-2c78-45af-b6a5-835b952ceb11&fromEditor=true

import UIKit

class OrderConfirmViewController: UIViewController {
    
    var address:GetAddressListItemData?
    var items:[CarDetils] = []
    var product:GetProductDetilsData? = nil
    var amount:Double = 0
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getDelAddress()
    }
    
    func setUI() {
        self.title = "Confirmar pedido"
        tableView.register(UINib(nibName: "ComfirmAddressCell", bundle: nil), forCellReuseIdentifier: "ComfirmAddressCell")
        tableView.register(UINib(nibName: "ConfirmItemCell", bundle: nil), forCellReuseIdentifier: "ConfirmItemCell")
        
        if let product = product {
            amount = Double(product.skuList[0].newPrice) ?? 0
            total.text = kUnit + String(amount)
        } else {
            amount = items.reduce(0) { partialResult, item in
                partialResult + Double(item.amount) * (Double(item.newPrice) ?? 0)
            }
            total.text = kUnit + String(amount)
        }
        
        let bottomH = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        bottomConstraint.constant = bottomH
    }
    
    func getDelAddress() {
        startLoading()
        NetWork.request(.getDelAddress,
                        modelType: GetDelAddressData.self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.address = model.detils
                self.tableView.reloadData()
            }
            self.stopLoading()
        }
    }
    
    @IBAction func confirm() {
        if let _ = product {
            payProduct()
        } else {
            payProductByCar()
        }
    }
    
    func payProduct() {
        if let product = product, let address = self.address, !address.addressId.isEmpty  {
            let dic = ["productId":product.product.productId,
                       "skuId":product.skuList[0].skuId,
                       "amount":"1",
                       "addressId":address.addressId]
            startLoading()
            NetWork.request(.payProduct,
                            modelType: GetPayProductData.self,
                            parameters: dic) { result, model, msg in
                if let model = model {
                    self.goBank(order: model)
                }
                self.stopLoading()
            }
        }
    }
    
    func payProductByCar() {
        let carIds = items.map { item in
            item.carId
        }.joined(separator: ",")
        
        if !carIds.isEmpty, let address = self.address, !address.addressId.isEmpty {
            let dic = ["carIds":carIds, "addressId":address.addressId]
            startLoading()
            NetWork.request(.payProductByCar,
                            modelType: GetPayProductData.self,
                            parameters: dic) { result, model, msg in
                if let model = model {
                    self.goBank(order: model)
                }
                self.stopLoading()
            }
        }
    }
    
    func goBank(order:GetPayProductData) {
        Router.push(.Bank(order: order, category: "1"), from: self)
    }
}

extension OrderConfirmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension OrderConfirmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComfirmAddressCell", for: indexPath) as! ComfirmAddressCell
            cell.tapAction = { [weak self] in
                guard let self = self else { return }
//                Router.push(.AddressList(action: { data in
//                    self.address = data
//                    self.tableView.reloadData()
//                }), from: self)
            }
            if let address = self.address, !address.addressId.isEmpty {
                cell.config(address)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmItemCell", for: indexPath) as! ConfirmItemCell
            if let product = product {
                cell.config(product)
            } else {
                cell.config(items)
            }
            return cell
        }
    }
}
