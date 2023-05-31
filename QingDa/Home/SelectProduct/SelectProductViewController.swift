//
//  SelectViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=e3f7b038-a374-426c-b443-ec7cde603af3&fromEditor=true

import UIKit

class SelectProductViewController: UIViewController {
    var pageNumber = 1
    let pageSize = 10
    var time:TimeInterval = 0
    var searchType = 0
    
    var leftItems : [GetProductTypeData] = []
    var rightItems : [GetProductListData] = []
    var selectRow = 0
    @IBOutlet weak var viewLeft: UITableView!
    @IBOutlet weak var viewRight: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getProductType()
    }
    
    func setUI() {
        self.title = "Escolha o modelo de celular"
        
        viewLeft.register(UINib(nibName: "LeftRowCell", bundle: nil), forCellReuseIdentifier: "LeftRowCell")
        viewRight.register(UINib(nibName: "ProductRightRowCell", bundle: nil), forCellReuseIdentifier: "ProductRightRowCell")
        
        let searchBar = SearchBar()
        var rect = searchBar.frame;
        rect.size.width = kScreenW - 100
        rect.size.height = 40
        searchBar.frame = rect
        searchBar.searchAction = { [weak self] (word) in
            guard let self = self else { return }
            Router.push(.SearchResult(word: word), from: self)
        }
        self.navigationItem.titleView = searchBar
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: IMAGE("组 57052").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(goCart))
        
        viewRight.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getProductList()
        })
    }
    
    func getProductType() {
        startLoading()
        NetWork.request(.getProductType,
                        modelType: [GetProductTypeData].self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.leftItems = model
                self.viewLeft.reloadData()
                self.getProductList()
            }
            self.stopLoading()
        }
    }
    
    func getProductList() {
        var dic = [
            "pageNumber" : String(pageNumber),
            "pageSize" : String(pageSize),
            "typeId" : leftItems[selectRow].typeId
        ]
        if searchType > 0 {
            dic["searchType"] = String(searchType)
        }
        
        if self.pageNumber == 1 {
            startLoading()
        }
        
        let time = NSDate().timeIntervalSince1970
        self.time = time
        NetWork.request(.getProductList,
                        modelType: [GetProductListData].self,
                        parameters: dic) { result, model, msg in
            if time != self.time { return }
            if let model = model {
                if model.count > 0 {
                    if self.pageNumber == 1 {
                        self.rightItems = model
                    } else {
                        self.rightItems += model
                    }
                    self.pageNumber += 1
                
                    self.viewRight.reloadData()
                    self.viewRight.mj_footer?.endRefreshing()
                } else {
                    self.viewRight.mj_footer?.endRefreshingWithNoMoreData()
                }
            } else {
                self.viewRight.mj_footer?.endRefreshing()
            }
            self.stopLoading()
        }
    }
    
    @objc
    func goCart() {
        Router.push(.Cart, from: self)
    }
    
    @IBAction func rank(btn:UIButton){
        searchType = btn.tag
        reloadRight()
        for view in stackView.arrangedSubviews {
            if let btn = view as? UIButton {
                btn.isSelected = false
            }
        }
        btn.isSelected = true
    }
    
    func reloadRight() {
        self.pageNumber = 1
        self.rightItems = []
        self.viewRight.reloadData()
        self.getProductList()
    }
}

extension SelectProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.tag == 0 ? 56 : 112
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            selectRow = indexPath.row
            self.viewLeft.reloadData()
            reloadRight()
        } else {
            Router.push(.Product(productId: rightItems[indexPath.row].productId),
                        from: self)
        }
    }
}

extension SelectProductViewController: UITableViewDataSource {
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
            leftCell.title.text = leftItems[indexPath.row].typeName
            leftCell.select = selectRow == indexPath.row
            return leftCell
        } else {
            let rightCell = tableView.dequeueReusableCell(withIdentifier: "ProductRightRowCell", for: indexPath) as! ProductRightRowCell
            rightCell.config(rightItems[indexPath.row])
            return rightCell
        }
    }
}
