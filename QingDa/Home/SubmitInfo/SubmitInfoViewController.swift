//
//  SubmitInfoViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/27.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=ece50e63-694c-4d2d-94bd-7ee4eb1bd6bf&fromEditor=true

import UIKit

class SubmitInfoViewController: UIViewController {
    
    var sum:Double = 0
    var data = GetRepairPhoneData(brandId: "", name: "")
    var items : [GetRepairModelDetilsData] = []
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUI()
        getRepairModelDetils()
    }
    
    func setUI() {
        self.title = "Enviar mensagem"
        header.text = data.name
        tableView.register(UINib(nibName: "SubmitInfoCell", bundle: nil), forCellReuseIdentifier: "SubmitInfoCell")
        
        container.layer.borderWidth = 1
        container.layer.borderColor = HEX(kMainColor1).cgColor
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = true
        
        count()
    }
    
    func getRepairModelDetils() {
        startLoading()
        NetWork.request(.getRepairModelDetils,
                        modelType: [GetRepairModelDetilsData].self,
                        parameters: ["brandId":data.brandId]) { result, model, msg in
            if let model = model {
                self.stopLoading()
                self.items = model
                self.tableView.reloadData()
            } else {
                self.showError()
            }
        }
    }
    
    func count() {
        var sum:Double = 0
        for value in items {
            if value.row >= 0 {
                sum += Double(value.optionJson[value.row].price) ?? 0
            }
        }
        self.sum = sum
        leftLabel.text = kUnit + String(sum)
    }
    
    @IBAction
    func goConfirm() {
        if sum > 0 {
            let items = items.filter { $0.row >= 0 }
            Router.push(.SubmitConfirm(items:items, data: data), from: self)
        }
    }
    @IBAction
    func goTel() {
        tel()
    }
}

extension SubmitInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension SubmitInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitInfoCell", for: indexPath) as! SubmitInfoCell
        cell.config(items[indexPath.row], index: indexPath.row)
        cell.tapAction = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.count()
        }
        return cell
    }
}
