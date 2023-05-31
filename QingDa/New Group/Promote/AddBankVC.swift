//
//  AddBankVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import UIKit
import Toaster

class AddBankVC: UIViewController {
    
    @IBOutlet weak var bankName:UITextField!
    @IBOutlet weak var userName:UITextField!
    @IBOutlet weak var account:UITextField!
    @IBOutlet weak var phone:UITextField!
    var bank:BankListResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        title = "添加银行卡"
        if let bank = bank{
            bankName.text = bank.bankName
            userName.text = bank.userName
            account.text = bank.account
            phone.text = bank.phone
        }
    }
    
    @IBAction func save() {
        var dic = [
            "bankName":bankName.text ?? "",
            "userName":userName.text ?? "",
            "account":account.text ?? "",
            "phone":phone.text ?? "",
        ]
        if let bank = bank {
            dic["id"] = bank.id
        }
        NetWork.request((bank != nil ? .updateBank : .addBank),
                        modelType: [NoneResponseData].self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                Toast(text: "保存成功", duration: 0.5).show()
                self.close();
            }
        }
    }
    
    @IBAction func delete() {
        if bank != nil {
            NetWork.request(.deleteBank,
                            modelType: [NoneResponseData].self,
                            parameters: ["id":bank!.id]) { result, model, msg in
                if let _ = model {
                    Toast(text: "删除成功", duration: 0.5).show()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            close()
        }
    }
    
    func close() {
        self.navigationController?.popViewController(animated: true)
    }
}
