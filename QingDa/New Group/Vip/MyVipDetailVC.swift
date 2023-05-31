//
//  MyVipDetailVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/1.
//

import UIKit
import Toaster

class MyVipDetailVC: UIViewController {
    
    var orderNumber: String = ""
    var items: [SysVipDetilsJson] = []
    var items2: [SysVipDetilsJson] = []
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var exchange: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getMyVipOrderDetils()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setUI() {
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 164)
        gradient.colors = [HEX("#FDECD9").cgColor, HEX("FEF4E8").cgColor, HEX("F7F7F7").cgColor]
        gradient.locations = [0, 0.57, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        collectionView?.register(UINib(nibName: "JiaoFuCell", bundle: nil), forCellWithReuseIdentifier: "JiaoFuCell")
    }
    
    func getMyVipOrderDetils() {
        let dic = [
            "orderNumber" : orderNumber,
        ]
        NetWork.request(.getMyVipOrderDetils,
                        modelType: GetMyVipOrderDetilsResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.items2 = model.objectList.map { $0.objectJson }
                self.collectionView?.reloadData()
                self.config(data: model.orderDetils)
            }
        }
    }
    
    func config(data: GetMyVipOrderDetils) {
        if data.state == "1" {
            self.items = data.sysPackageJson.filter({ item in
                !self.items2.contains { item2 in
                    item2.objectId == item.objectId
                }
            })
            title = "任选套餐内\(data.sysAmount)套课程"
            exchange.setTitle("立即兑换，剩余\(data.surplusAmount)次", for: .normal)
            exchangeView.isHidden = false
        } else {
            self.items = self.items2
            exchangeView.isHidden = true
            title = "兑换详情"
            tableView.tableHeaderView = nil
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction
    func goExchange() {
        let dic = [
            "orderNumber" : orderNumber,
            "objectIds" : items.filter { $0.select }.map { $0.objectId }.joined(separator: ",")
        ]
        NetWork.request(.chooseCourse,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                Toast(text: "兑换成功", duration: 0.5).show()
                self.getMyVipOrderDetils()
            }
        }
    }
}

extension MyVipDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.config(items[indexPath.row])
        cell.select.isHidden = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].select = !items[indexPath.row].select
        tableView.reloadData()
    }
}


extension MyVipDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JiaoFuCell", for: indexPath) as! JiaoFuCell
        cell.config(items2[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items2.count
    }
}

extension MyVipDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 96, height: 167)
    }
}
