//
//  PayVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/23.
//

import UIKit

enum PayType {
    case unknown
    case vip(price: String, vipId: String)
    case course(price: String, objectId:String, couponId:String?, category:String)
}

class PayVC: UIViewController {
    
    var type = PayType.unknown
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var check2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
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
        self.title = "支付方式"
        switch type {
        case .unknown:
            priceL.text = ""
        case let .vip(price, _):
            priceL.text = "¥" + price
        case let .course(price, _, _, _):
            priceL.text = "¥" + price
        }
    }
    
    @IBAction func pay() {
        let payType = check.isSelected ? "2" : "1"
        switch type {
        case .unknown:
            return
        case let .vip(_, vipId):
            orderVip(vipId, payType)
        case let .course(_, objectId, couponId, category):
            createCourseOrder(objectId: objectId,
                              couponId: couponId,
                              category: category,
                              payType: payType)
        }
    }
    
    @IBAction func click(button: UIButton) {
        if button.isSelected {
            return
        }
        if button == check {
            check.isSelected = true
            check2.isSelected = false
        } else {
            check.isSelected = false
            check2.isSelected = true
        }
    }
}
