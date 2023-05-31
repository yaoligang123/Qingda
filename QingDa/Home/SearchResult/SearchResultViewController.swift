//
//  SearchResultViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/2.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=65e0720b-f282-429c-9e56-863a07b385b2&fromEditor=true

import UIKit

class SearchResultViewController: UIViewController {
    
    var pageNumber = 1
    let pageSize = 10
    
    var word = ""
    var items:[GetProductListData] = []
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        getProductList()
    }
    
    func setUI() {
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "SearchResultCell")
        searchBar.textField.text = word
        searchBar.searchAction = { [weak self] (word) in
            guard let self = self else { return }
            self.items = []
            self.tableView.reloadData()
            self.pageNumber = 1
            self.getProductList()
        }
        
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getProductList()
        })
    }

    func getProductList() {
        if let word = searchBar.textField.text, word.count > 0 {
            let dic = [
                "pageNumber" : String(pageNumber),
                "pageSize" : String(pageSize),
                "searchValue" : word
            ]
            if self.pageNumber == 1 {
                startLoading()
            }
            NetWork.request(.getProductList,
                            modelType: [GetProductListData].self,
                            parameters: dic) { result, model, msg in
                if let model = model {
                    if model.count > 0 {
                        if self.pageNumber == 1 {
                            self.items = model
                        } else {
                            self.items += model
                        }
                        self.pageNumber += 1
                        self.tableView.reloadData()
                        self.tableView.mj_footer?.endRefreshing()
                    } else {
                        self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                    self.tableView.reloadData()
                } else {
                    self.tableView.mj_footer?.endRefreshing()
                }
                self.stopLoading()
            }
        }
    }
}

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.push(.Product(productId: items[indexPath.row].productId), from: self)
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        cell.config(items[indexPath.row])
        return cell
    } 
}
