//
//  SelectViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=dc9e1631-6f80-44d9-ba6c-eb59c3956493&fromEditor=true

import UIKit

enum SelectType {
    case SelectPhoneTypePhone
    case SelectPhoneTypePC
}

class SelectViewController: UIViewController {
    var type = SelectType.SelectPhoneTypePhone
    var leftItems : [GetRepairPhoneData] = []
    var rightItems : [GetRepairPhoneData] = []
    var selectRow = 0
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var viewLeft: UITableView!
    @IBOutlet weak var viewRight: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getRepairPhone()
    }
    
    func setUI() {
        self.title = "Escolha o modelo de celular"
        
        viewLeft.register(UINib(nibName: "LeftRowCell", bundle: nil), forCellReuseIdentifier: "LeftRowCell")
        viewRight.register(UINib(nibName: "RightRowCell", bundle: nil), forCellReuseIdentifier: "RightRowCell")
        
        searchBar.searchAction = { [weak self] (word) in
            guard let self = self else { return }
            Router.push(.SearchRepairResult(type: self.type, word: word), from: self)
        }
    }
    
    func getRepairPhone() {
        startLoading()
        NetWork.request(.getRepairPhone,
                        modelType: [GetRepairPhoneData].self,
                        parameters: ["category":getCategory()]) { result, model, msg in
            if let model = model, model.count > 0 {
                self.leftItems = model
                self.viewLeft.reloadData()
                self.getRepairModel()
            }
            self.stopLoading()
        }
    }
    
    func getRepairModel() {
        let dic = [
            "category" : getCategory(),
            "brandId" : leftItems[selectRow].brandId
        ]
        startLoading()
        NetWork.request(.getRepairModel,
                        modelType: [GetRepairPhoneData].self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.rightItems = model
                self.viewRight.reloadData()
            }
            self.stopLoading()
        }
    }
    
    func getCategory() -> String {
        type == SelectType.SelectPhoneTypePhone ? "1" : "2"
    }
}

extension SelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.tag == 0 ? 56 : 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            selectRow = indexPath.row
            self.getRepairModel()
            self.viewLeft.reloadData()
        } else {
            Router.push(.SubmitInfo(data: rightItems[indexPath.row]),
                        from: self)
        }
    }
}

extension SelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return leftItems.count
        } else {
            return rightItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let leftCell = tableView.dequeueReusableCell(withIdentifier: "LeftRowCell", for: indexPath) as! LeftRowCell
            leftCell.title.text = leftItems[indexPath.row].name
            leftCell.select = selectRow == indexPath.row
            return leftCell
        } else {
            let rightCell = tableView.dequeueReusableCell(withIdentifier: "RightRowCell", for: indexPath) as! RightRowCell
            rightCell.title.text = rightItems[indexPath.row].name
            return rightCell
        }
    }
}
