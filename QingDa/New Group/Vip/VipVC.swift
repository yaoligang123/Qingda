//
//  VipVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import UIKit

class VipVC: UIViewController {
    
    var titleStrings = ["课程会员", "试卷会员"]
    var items: [SysVipListResponse] = []
    var index = 0
    @IBOutlet weak var control:SegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sysVipList()
    }
    
    func titles() -> [NSAttributedString] {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]
        var titles = [NSAttributedString]()
        for titleString in titleStrings {
            let title = NSAttributedString(string: titleString, attributes: attributes)
            titles.append(title)
        }
        return titles
    }
    
    func selectedTitles() -> [NSAttributedString] {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: HEX(kMainColor1)]
        var selectedTitles = [NSAttributedString]()
        for titleString in titleStrings {
            let selectedTitle = NSAttributedString(string: titleString, attributes: attributes)
            selectedTitles.append(selectedTitle)
        }
        return selectedTitles
    }
    
    func setControl() {
        control.setTitles(titles(), selectedTitles: selectedTitles())
        control.delegate = self
        control.selectionIndicatorStyle = .bottom
        control.layoutPolicy = .dynamic
        control.selectionIndicatorColor = HEX(kMainColor1)
        control.selectionIndicatorHeight = 4
        control.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        control.setSelected(at: 1, animated: false)
        control.setSelected(at: 0, animated: false)
    }

    func setUI() {
        self.title = "会员套餐"
        
        let item = UIBarButtonItem.init(title: "我的购买", style: .plain, target: self, action: #selector(goBuy))
        item.tintColor = HEX(kMainColor1)
        navigationItem.rightBarButtonItem = item
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 164)
        gradient.colors = [HEX("#FDECD9").cgColor, HEX("FEF4E8").cgColor, HEX("FFFFFF").cgColor]
        gradient.locations = [0, 0.57, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        setControl()
        tableView.register(UINib(nibName: "VipCell", bundle: nil), forCellReuseIdentifier: "VipCell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom:0, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc
    func goBuy() {
        Router.push(.MyVip, from: self)
    }
    
    
    func sysVipList() {
        NetWork.request(.sysVipList,
                        modelType: [SysVipListResponse].self,
                        parameters: ["category":"\(index + 1)"]) { result, model, msg in
            if let model = model {
                self.items = model
                self.tableView.reloadData()
            }
        }
    }

}

extension VipVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VipCell", for: indexPath) as! VipCell
        cell.config(items[indexPath.row])
        cell.collectionView.isHidden = index == 1
        cell.line.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        index == 0 ? 218 : 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.push(.VipDetail(vipId: items[indexPath.row].vipId,
                               appleId: items[indexPath.row].appleId), from: self)
    }
}

extension VipVC: SegmentedControlDelegate {
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelectIndex selectedIndex: Int) {
        index = selectedIndex
        sysVipList()
    }
}
