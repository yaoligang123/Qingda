//
//  RepairOrderViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/19.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=0acd71f0-ee40-476d-84fb-51aab3223f9e&fromEditor=true

import UIKit

class RepairOrderViewController: UIViewController {
    
    var data:String = ""
    var model:GetServerOrderDetilsData?
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getServerOrderDetils()
    }
    
    func setUI() {
        self.title = "Gerar um pedido"
        tableView.register(UINib(nibName: "SubmitInputCell", bundle: nil), forCellReuseIdentifier: "SubmitInputCell")
        tableView.register(UINib(nibName: "SubmitDetailCell", bundle: nil), forCellReuseIdentifier: "SubmitDetailCell")
        tableView.register(UINib(nibName: "StoreCell", bundle: nil), forCellReuseIdentifier: "StoreCell")
        tableView.register(UINib(nibName: "ComfirmAddressCell", bundle: nil), forCellReuseIdentifier: "ComfirmAddressCell")
        
        leftBtn.layer.borderWidth = 1
        leftBtn.layer.borderColor = HEX(kMainColor1).cgColor
    }
    
    func getServerOrderDetils() {
        startLoading(transparent: false)
        NetWork.request(.getServerOrderDetils,
                        modelType: GetServerOrderDetilsData.self,
                        parameters: ["orderNumber" : data]) { result, model, msg in
            if let model = model {
                self.model = model
                self.config()
                self.tableView.reloadData()
                self.stopLoading()
            } else {
                self.showError()
            }
        }
    }
    
    func config() {
        if let model = model {
            self.category.text = model.detils.category == "1" ? "Serviço na loja" : "Serviço delivery"
            let state = model.detils.state
            self.state.text = stringFromRepairState(state)
            
            bottomView.isHidden = !(state == "2" || state == "3")
            
            let bottomH = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            bottomConstraint.constant = bottomView.isHidden ? 0 : bottomH + 60
        }
    }
    
    @IBAction func cancel() {
        startLoading()
        NetWork.request(.serverOrderUpdate,
                        modelType: NoneResponseData.self,
                        parameters: ["orderNumber":data, "state" : "1"]) { result, model, msg in
            if let _ = model {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
            }
            self.stopLoading()
        }
    }
    
    @IBAction func goStore() {
        if let store = gStore {
            Router.push(.Map(data: store),
                        from: self)
        }
    }
}

extension RepairOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0,
           let model = model,
           model.detils.category == "1",
           let store = gStore {
            Router.push(.Map(data: store),
                        from: self)
        }
    }
}

extension RepairOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            if let model = model {
                if model.detils.category == "1" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
                    cell.config(model.store)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ComfirmAddressCell", for: indexPath) as! ComfirmAddressCell
                    cell.config(model.detils)
                    return cell
                }
            }
        } else if section == 1 || section == 2 || section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitInputCell", for: indexPath) as! SubmitInputCell
            
            if section == 1 {
                cell.title.text = "Senha (opcional):"
                cell.input.isUserInteractionEnabled = false
                cell.input.text = model?.detils.lockScreenPassword
            } else if section == 2 {
                cell.title.text = "Data orçamento:"
                cell.input.isUserInteractionEnabled = false
                cell.input.text = model?.detils.reservationDate
            } else if section == 3 {
                cell.title.text = "Hora orçamento:"
                cell.input.isUserInteractionEnabled = false
                cell.input.text = model?.detils.reservationTime
            }
            
            return cell
        } else if section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitDetailCell", for: indexPath) as! SubmitDetailCell
            if let model = model {
                cell.config(data: model)
            }
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
}
