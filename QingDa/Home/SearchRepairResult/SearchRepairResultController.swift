//
//  SearchRepairResultController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/2.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=33f01cac-742e-4fbb-98f4-5b78ea00e802&fromEditor=true

import UIKit

class SearchRepairResultController: UIViewController {
    
    var type = SelectType.SelectPhoneTypePhone
    var word = ""
    var items : [GetRepairPhoneData] = []
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        getRepairModel()
    }
    
    func setUI() {
        title = "Escolha conserto de celular"
        
        tableView.register(UINib(nibName: "SearchRepairResultCell", bundle: nil), forCellReuseIdentifier: "SearchRepairResultCell")
        searchBar.textField.text = word
        
        searchBar.searchAction = { [weak self] (word) in
            guard let self = self else { return }
            self.items = []
            self.tableView.reloadData()
            self.getRepairModel()
        }
    }
    
    func getRepairModel() {
        if let word = searchBar.textField.text, word.count > 0 {
            let dic = [
                "category" : getCategory(),
                "searchValue" : word
            ]
            startLoading()
            NetWork.request(.getRepairModel,
                            modelType: [GetRepairPhoneData].self,
                            parameters: dic) { result, model, msg in
                if let model = model {
                    self.items = model
                    self.tableView.reloadData()
                }
                self.stopLoading()
            }
        }
    }
    
    func getCategory() -> String {
        type == SelectType.SelectPhoneTypePhone ? "1" : "2"
    }    
}

extension SearchRepairResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.push(.SubmitInfo(data: items[indexPath.row]), from: self)
    }
}

extension SearchRepairResultController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchRepairResultCell", for: indexPath) as! SearchRepairResultCell
        cell.title.text = items[indexPath.row].name
        return cell
    }
}
