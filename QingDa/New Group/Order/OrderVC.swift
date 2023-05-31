//
//  OrderVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import UIKit

class OrderVC: UIViewController {
    
    var items: [GetMyOrderCourseListItem] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getMyOrderCourseList()
    }
    
    func setUI() {
        self.title = "我的订单"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        tableView.register(UINib(nibName: "OrdCell", bundle: nil), forCellReuseIdentifier: "OrdCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func getMyOrderCourseList() {
        let dic = [
            "pageNumber" : 1,
            "pageSize" : 100,
        ]
        NetWork.request(.getMyOrderCourseList,
                        modelType: GetMyOrderCourseListResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.items = model.records
                self.tableView.reloadData()
            }
        }
    }
    
}

extension OrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdCell", for: indexPath) as! OrdCell
        cell.config(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        204
    }
}
