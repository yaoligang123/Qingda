//
//  OrderViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/3.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=bc9ff919-5369-499e-8fa6-c9cff73d0326&fromEditor=true

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=7df5a070-0335-4b31-a292-a24e2a04e0fe&fromEditor=true

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=60c3f7b0-4c93-455b-a054-1efd339ca1f6&fromEditor=true


import UIKit
import Kingfisher


let RefreshOrderNotification = NSNotification.Name(rawValue: "RefreshOrderNotification")

class OrderViewController: UIViewController {
    
    var fromMe = false
    var pageNumberProduct = 1
    var pageNumberRepair = 1
    let pageSize = 10
    var listProduct: [ProductOrderData] = []
    var listRepair: [GetServerOrderListItem] = []
    var tagProduct = 1
    @IBOutlet weak var tabRepair: UIButton!
    @IBOutlet weak var tabProduct: UIButton!
    @IBOutlet weak var tabItemRepair: UIView!
    @IBOutlet weak var tabItemProduct: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTab), name: RefreshOrderNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if fromMe {
            tabItemProduct.tag = tagProduct
            select(btn: tabProduct)
        }
        fromMe = false
    }
    
    func setUI() {
        tableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            if self.tabRepair.isSelected {
                self.getServerOrderList()
            } else {
                self.getProductOrderList()
            }
        })
        configTab(tab: tabItemRepair)
        configTab(tab: tabItemProduct)
        
        if !fromMe {
            select(btn: tabRepair)
        }
    }
    
    @IBAction func select(btn:UIButton) {
        if tabRepair.isSelected && btn == tabRepair { return }
        if tabProduct.isSelected && btn == tabProduct && !fromMe { return }
        
        tabRepair.isSelected = btn == tabRepair
        tabProduct.isSelected = !tabRepair.isSelected
        tabItemRepair.isHidden = !tabRepair.isSelected
        tabItemProduct.isHidden = !tabProduct.isSelected
        
        if tabRepair.isSelected {
            selectTab(tab: tabItemRepair, index: tabItemRepair.tag)
        } else {
            selectTab(tab: tabItemProduct, index: tabItemProduct.tag)
        }
    }
    
    func selectTab(tab:UIView, index:Int) {
        tab.tag = index
        for subview in tab.subviews {
            (subview as? OrderTab)?.select = subview.tag == index
        }
        reloadTab()
    }
    
    @objc func reloadTab() {
        if tabRepair.isSelected {
            pageNumberRepair = 1
            listRepair = []
            getServerOrderList()
        } else {
            pageNumberProduct = 1
            listProduct = []
            getProductOrderList()
        }
        tableView.reloadData()
    }
    
    func configTab(tab:UIView) {
        for subview in tab.subviews {
            (subview as? OrderTab)?.tapAction = { [weak self] in
                guard let self = self else { return}
                self.selectTab(tab: subview.superview!, index: subview.tag)
            }
        }
    }
    
    func getProductOrderList() {
        let dic = [
            "pageNumber" : String(pageNumberProduct),
            "pageSize" : String(pageSize),
            "state" : String(tabItemProduct.tag)
        ]
        
        startLoading()
        NetWork.request(.getProductOrderList,
                        modelType:GetProductOrderList.self,
                        parameters:dic) { result, model, msg in
            if let model = model {
                if model.list.count > 0 {
                    if self.pageNumberProduct == 1 {
                        self.listProduct = model.list
                    } else {
                        self.listProduct += model.list
                    }
                    self.pageNumberProduct += 1
                    self.tableView.mj_footer?.endRefreshing()
                } else {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
                self.tableView.reloadData()
            }
            self.stopLoading()
        }
    }
    
    func getServerOrderList() {
        let dic = [
            "pageNumber" : String(pageNumberRepair),
            "pageSize" : String(pageSize),
            "state" : String(tabItemRepair.tag)
        ]
        
        startLoading()
        NetWork.request(.getServerOrderList,
                        modelType:GetServerOrderListData.self,
                        parameters:dic) { result, model, msg in
            if let model = model {
                if model.list.count > 0 {
                    if self.pageNumberRepair == 1 {
                        self.listRepair = model.list
                    } else {
                        self.listRepair += model.list
                    }
                    self.pageNumberRepair += 1
                    
                    self.tableView.mj_footer?.endRefreshing()
                } else {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
                self.tableView.reloadData()
            }
            self.stopLoading()
        }
    }
}

extension OrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tabRepair.isSelected {
            Router.push(.RepairOrder(data: listRepair[indexPath.row].orderNumber), from: self)
        } else {
            Router.push(.ProductOrder(data: listProduct[indexPath.row]), from: self)
        }
    }
}

extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabRepair.isSelected ? listRepair.count : listProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        if tabRepair.isSelected {
            cell.config(listRepair[indexPath.row])
        } else {
            cell.config(listProduct[indexPath.row])
        }
        cell.vc = self
        return cell
    }
}
