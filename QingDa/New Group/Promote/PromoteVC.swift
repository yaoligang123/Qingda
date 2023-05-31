//
//  PromoteVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import UIKit

class PromoteVC: UIViewController {
    
    var data: PromoterMoneyResponse? = nil {
        didSet {
            if let data = data{
                rmbBalance.text = "¥\(data.rmbBalance)"
                inviteCount.text = data.inviteCount
                teamPayCount.text = data.teamPayCount
                rmbTotal.text = data.rmbTotal
            }
        }
    }
    
    var index = 0 {
        didSet {
            line1.isHidden = index == 1
            line2.isHidden = index == 0
        }
    }
    @IBOutlet weak var rmbBalance:UILabel!
    @IBOutlet weak var inviteCount:UILabel!
    @IBOutlet weak var teamPayCount:UILabel!
    @IBOutlet weak var rmbTotal:UILabel!
    @IBOutlet weak var line1:UIImageView!
    @IBOutlet weak var line2:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        promoterMoney()
    }
    
    func setUI() {
        self.title = "推广员"
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 162)
        gradient.colors = [HEX("#FF5D00").cgColor, HEX("#FE8328").cgColor]
        gradient.locations = [0, 0.57, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func promoterMoney() {
        NetWork.request(.promoterMoney,
                        modelType: PromoterMoneyResponse.self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.data = model
            }
        }
    }
    
    @IBAction func select(btn: UIButton) {
        index = btn.tag
    }
    
    @IBAction func money() {
        Router.push(.Money, from: self)
    }
    
    @IBAction func share() {
        Router.push(.Share, from: self)
    }
}
