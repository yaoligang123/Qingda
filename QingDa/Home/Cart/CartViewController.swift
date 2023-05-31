//
//  CartViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/1.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=17f004c4-93bb-4ee8-bf65-23dc2d9f300a&fromEditor=true

import UIKit

class CartViewController: UIViewController {
    
    var items:[CarDetils] = []
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        carDetils()
    }
    
    func setUI() {
        self.title = "Carrinho de compra"
        
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = HEX(kMainColor1).cgColor
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
    }
    
    func carDetils() {
        startLoading(transparent: false)
        NetWork.request(.carDetils,
                        modelType: CarDetilsData.self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.items = model.list
                self.label.isHidden = model.list.count > 0
                self.imageView.isHidden = self.label.isHidden
                self.view.backgroundColor = self.label.isHidden ? HEX("#F7F7F7") : .white
                self.tableView.reloadData()
                self.stopLoading()
            } else {
                self.showError()
            }
        }
    }
    
    @IBAction
    func delete() {
        var carIds:[String] = []
        for item in items {
            if item.select {
                carIds.append(item.carId)
            }
        }
        if carIds.count > 0 {
            let dic = ["carIds" : carIds.joined(separator: ",")]
            startLoading()
            NetWork.request(.deleteCar,
                            modelType: NoneResponseData.self,
                            parameters: dic) { result, model, msg in
                if let _ = model {
                    self.items = self.items.filter { !$0.select }
                    self.tableView.reloadData()
                }
                self.stopLoading()
            }
        }
    }
    
    @IBAction
    func confirm() {
        let selectItems = self.items.filter { $0.select }
        if selectItems.count > 0 {
            Router.push(.OrderConfirm(items: selectItems), from: self)
        }
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if items[indexPath.row].state == "1" {
            items[indexPath.row].select = !items[indexPath.row].select
            tableView.reloadData()
        }
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.config(items[indexPath.row])
        return cell
    }
}
