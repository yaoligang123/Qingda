//
//  MyVipVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import UIKit

extension MyVipVC: CustomSegmentedControlDelegate {
    func change(to index:Int) {
        items = []
        tableView.reloadData()
        self.selectedIndex = index
        getMyVipOrderList()
    }
}

class MyVipVC: UIViewController {
    var selectedIndex = 0
    var tabs = ["待使用", "已使用", "已过期"]
    var category = ["1", "2", "3"]
    var items: [GetMyVipOrderListItem] = []
    @IBOutlet weak var control:CustomSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMyVipOrderList()
    }
    
    func setUI() {
        self.title = "我的会员"
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 164)
        gradient.colors = [HEX("#FDECD9").cgColor, HEX("FEF4E8").cgColor, HEX("FFFFFF").cgColor]
        gradient.locations = [0, 0.57, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        control.setButtonTitles(buttonTitles: tabs)
        control.delegate = self
        
        tableView.register(UINib(nibName: "VipCell", bundle: nil), forCellReuseIdentifier: "VipCell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom:0, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func getMyVipOrderList() {
        let dic = [
            "pageNumber" : 1,
            "pageSize" : 100,
            "category" : category[selectedIndex],
        ] as [String : Any]
        NetWork.request(.getMyVipOrderList,
                        modelType: GetMyVipOrderListResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.items = model.records
                self.tableView.reloadData()
            }
        }
    }
}

extension MyVipVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VipCell", for: indexPath) as! VipCell
        cell.config(items[indexPath.row], selectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        218
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == 2 {
            return
        }
        Router.push(.MyVipDetail(orderNumber: items[indexPath.row].orderNumber), from: self)
    }
}
