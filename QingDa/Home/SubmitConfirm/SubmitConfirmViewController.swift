//
//  SubmitConfirmViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/27.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=3def273d-eccb-47ff-818a-afa14f4881a5&fromEditor=true

import UIKit
import DatePickerDialog

class SubmitConfirmViewController: UIViewController {
    
    @IBOutlet weak var line1: UIImageView!
    @IBOutlet weak var line2: UIImageView!
    @IBOutlet weak var notice: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    var sum = ""
    var data = GetRepairPhoneData(brandId: "", name: "")
    var items : [GetRepairModelDetilsData] = []
    var address:GetAddressListItemData?
    var date:String = ""
    var start:String = ""
    var end:String = ""
    var password:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        count()
        setUI()
        getDelAddress()
    }
    
    func setUI() {
        self.title = "Escolha conserto de celular"
        tableView.register(UINib(nibName: "ComfirmAddressCell", bundle: nil), forCellReuseIdentifier: "ComfirmAddressCell")
        tableView.register(UINib(nibName: "StoreCell", bundle: nil), forCellReuseIdentifier: "StoreCell")
        tableView.register(UINib(nibName: "SubmitInputCell", bundle: nil), forCellReuseIdentifier: "SubmitInputCell")
        tableView.register(UINib(nibName: "SubmitDetailCell", bundle: nil), forCellReuseIdentifier: "SubmitDetailCell")
        
        container.layer.borderWidth = 1
        container.layer.borderColor = HEX(kMainColor1).cgColor
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = true
        
        total.text = kUnit + sum
    }
    
    @IBAction
    func select(btn:UIButton) {
        if !line1.isHidden && btn.tag == 0 { return }
        if !line2.isHidden && btn.tag == 1 { return }
        line1.isHidden = !line1.isHidden
        line2.isHidden = !line2.isHidden
        notice.isHidden = btn.tag == 0
        
        let header = tableView.tableHeaderView!
        var frame = header.frame
        if btn.tag == 0 {
            frame.size.height = 60
        } else {
            frame.size.height = 98
        }
        header.frame = frame
        tableView.tableHeaderView = header
        tableView.reloadData()
    }
    
    func count() {
        var sum:Double = 0
        for value in items {
            if value.row >= 0 {
                sum += Double(value.optionJson[value.row].price) ?? 0
            }
        }
        self.sum = String(sum)
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
        guard !date.isEmpty, !start.isEmpty, !end.isEmpty else { return }
        let list = items.compactMap { (data) -> NSDictionary? in
            if data.row >= 0 {
                let item = data.optionJson[data.row]
                return [
                    "optiona": item.optiona,
                    "price": item.price
                ]
            }
            return nil
        }
        var dic : [String : Any] = [
            "category" : line2.isHidden ? "1" : "2",
            "lockScreenPassword" : password,
            "reservationDate" : date,
            "reservationTime" : start + "-" + end,
            "phoneModel" : data.name,
            "price" : sum,
            "list" : list
        ]
        if line1.isHidden {
            guard let address = address else {
                return
            }
            dic["personName"] = address.personName
            dic["personPhone"] = address.personPhone
            dic["address"] = address.address
        }
        startLoading()
        NetWork.request(.createServerOrder,
                        modelType: GetPayProductData.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.goBank(order: model)
            }
            self.stopLoading()
        }
    }
    
    func goBank(order:GetPayProductData) {
        Router.push(.Bank(order: order, category: "2"), from: self)
    }
    
    @IBAction func goTel() {
        tel()
    }
}


extension SubmitConfirmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, line2.isHidden, let store = gStore {
            Router.push(.Map(data: store),
                        from: self)
        } else if indexPath.section == 2 {
            DatePickerDialog(locale: Locale(identifier: "pt_BR"), showCancelButton: false).show("Data orçamento",
                                    doneButtonTitle: "confirmar",
                                    datePickerMode: .date) { [weak self] date in
                if let dt = date {
                    formatter.dateFormat = "dd - MM - yyyy"
                    self?.date = formatter.string(from: dt)
                    self?.tableView.reloadData()
                }
            }
        } else if indexPath.section == 3 {
            DatePickerDialog(locale: Locale(identifier: "pt_BR"), showCancelButton: false).show("Hora orçamento",
                                    doneButtonTitle: "confirmar",
                                                                                                datePickerMode: .time) { [weak self] date in
                if let dt = date {
                    formatter.dateFormat = "HH:mm"
                    self?.start = formatter.string(from: dt)
                    DatePickerDialog(locale: Locale(identifier: "pt_BR"), showCancelButton: false).show("Hora orçamento",
                                            doneButtonTitle: "confirmar",
                                            minimumDate: dt,
                                            datePickerMode: .time) { [weak self] date in
                        if let dt = date {
                            formatter.dateFormat = "HH:mm"
                            self?.end = formatter.string(from: dt)
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension SubmitConfirmViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        if section == 0 {
            if line1.isHidden {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ComfirmAddressCell", for: indexPath) as! ComfirmAddressCell
                cell.tapAction = { [weak self] in
                    guard let self = self else { return }
//                    Router.push(.AddressList(action: { data in
//                        self.address = data
//                        self.tableView.reloadData()
//                    }), from: self)
                }
                if let address = self.address, !address.addressId.isEmpty {
                    cell.config(address)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
                if let store = gStore {
                    cell.config(store)
                }
                return cell
            }
        } else if section == 1 || section == 2 || section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitInputCell", for: indexPath) as! SubmitInputCell
            
            if section == 1 {
                cell.title.text = "Senha (opcional):"
                cell.input.placeholder = "Favor digitar sua senha"
                cell.input.isUserInteractionEnabled = true
                cell.input.text = password
                cell.inputAction = { [weak self] in
                    self?.password = cell.input.text ?? ""
                }
            } else if section == 2 {
                cell.title.text = "Data orçamento:"
                cell.input.isUserInteractionEnabled = false
                cell.input.placeholder = ""
                cell.input.text = date
            } else if section == 3 {
                cell.title.text = "Hora orçamento:"
                cell.input.isUserInteractionEnabled = false
                cell.input.placeholder = ""
                cell.input.text = start + "-" + end
            }
            
            return cell
        } else if section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitDetailCell", for: indexPath) as! SubmitDetailCell
            cell.config(items: items, data: data, total:sum)
            
            return cell
        }
        
        return UITableViewCell()
    }
}
