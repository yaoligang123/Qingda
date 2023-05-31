//
//  MoneyVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import UIKit
import Toaster

class MoneyVC: UIViewController {
    
    @IBOutlet weak var bank:UIView!
    @IBOutlet weak var money:UITextField!
    @IBOutlet weak var bankLabel:UILabel!
    var item: BankListResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        self.title = "提现"
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(goBank))
        bank.addGestureRecognizer(recognizer)
    }
    
    @objc
    func goBank() {
        Router.push(.BankList(tap: { bank in
            self.item = bank
            self.bankLabel.text = "\(bank.bankName)\r\(bank.account)"
        }), from: self)
    }

    @IBAction
    func submit() {
        if let item = item {
            NetWork.request(.applyTixian,
                            modelType: [NoneResponseData].self,
                            parameters: ["id":item.id, "money":money.text!]) { result, model, msg in
                if let _ = model {
                    Toast(text: "提现", duration: 0.5).show()
                }
            }
            
        } else {
            goBank()
        }
    }
}
