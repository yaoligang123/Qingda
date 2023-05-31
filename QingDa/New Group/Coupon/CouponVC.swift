//
//  CouponVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import UIKit

extension CouponVC: CustomSegmentedControlDelegate {
    func change(to index:Int) {
        items = []
        tableView.reloadData()
        self.selectedIndex = index
        getCoupon()
    }
}

class CouponVC: UIViewController {
    
    var selectedIndex = 0
    var tabs = ["待使用", "已使用", "已过期"]
    var category = ["1", "2", "3"]
    var items: [CouponResponse] = []
    @IBOutlet weak var control:CustomSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getCoupon()
    }
    
    func setUI() {
        self.title = "优惠券"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        control.setButtonTitles(buttonTitles: tabs)
        control.delegate = self
        
        tableView.register(UINib(nibName: "CouponCell", bundle: nil), forCellReuseIdentifier: "CouponCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func getCoupon() {
        let dic = [
            "category" : category[selectedIndex],
        ]
        NetWork.request(.coupon,
                        modelType: [CouponResponse].self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.items = model
                self.tableView.reloadData()
            }
        }
    }
}

extension CouponVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponCell
        cell.config(items[indexPath.row], selectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseId = items[indexPath.row].objectId
        let vc = items[indexPath.row].category == "3" ? RouterPage.Course2(courseId: courseId) : RouterPage.Course(courseId: courseId)
        Router.push(vc, from: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        98
    }
}
