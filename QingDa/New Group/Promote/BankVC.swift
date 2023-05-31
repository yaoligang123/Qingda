//
//  BankVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import UIKit

class BankVC: UIViewController {
    
    var tapAction: ((BankListResponse) -> Void)? = nil
    var items: [BankListResponse] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        title = "银行卡列表"
        
        tableView.register(UINib(nibName: "BankCell", bundle: nil), forCellReuseIdentifier: "BankCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bankList()
    }
    
    func bankList() {
        NetWork.request(.bankList,
                        modelType: [BankListResponse].self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.items = model
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addBank() {
        Router.push(.AddBank(bank: nil), from: self)
    }
}


extension BankVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell", for: indexPath) as! BankCell
        cell.config(items[indexPath.row])
        cell.editAction = {  [weak self] in
            guard let self = self else { return }
            Router.push(.AddBank(bank: self.items[indexPath.row]), from: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapAction?(self.items[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}
