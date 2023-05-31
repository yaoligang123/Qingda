//
//  ChangePwdVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/1.
//

import UIKit
import Toaster

class ChangePwdVC: UIViewController {
    
    var phone: String = ""
    var openid: String = ""
    var nickName: String = ""
    var headimage: String = ""
    var pwd = false
    @IBOutlet weak var row1:SettingRow!
    @IBOutlet weak var row2:SettingRow!
    @IBOutlet weak var row3:SettingRow!
    @IBOutlet weak var row4:SettingRow!
    
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
        self.title = pwd ? "修改密码" : "修改手机号"
        
        row2.change.setTitle("获取验证码", for: .normal)
        row2.textField.placeholder = "输入验证码"
        row2.showChange = true
        row2.btnAction = { [weak self] in
            guard let self = self else { return }
            self.sendCode()
        }
        row2.textField.isUserInteractionEnabled = true
        row1.textField.keyboardType = .numberPad
        row3.textField.keyboardType = .numberPad
        row4.textField.keyboardType = .numberPad
        
        if pwd {
            row1.textField.text = phone
            row3.title.text = "输入新密码"
            row4.title.text = "再次输入新密码"
            row3.textField.isUserInteractionEnabled = true
            row4.textField.isUserInteractionEnabled = true
        } else if phone.isEmpty {
            row1.title.text = "输入手机号"
            row1.textField.isUserInteractionEnabled = true
            row3.isHidden = true
            row4.isHidden = true
        } else {
            row1.textField.text = phone
            row3.textField.isUserInteractionEnabled = true
            row4.textField.isUserInteractionEnabled = true
        }
    }
    
    
    func sendCode() {
        guard !row1.textField.text!.isEmpty else {
            return
        }
        NetWork.request(.sendCode,
                        modelType: String.self,
                        parameters: ["category": pwd ? "2" : "4", "phone": row1.textField.text!]) { result, model, msg in
            if let model = model {
                self.row2.textField.text = model
            }
        }
    }
    
    func bindPhone() {
        guard !row1.textField.text!.isEmpty else {
            return
        }
        guard !row2.textField.text!.isEmpty else {
            return
        }
        
        NetWork.request(.bindPhone,
                        modelType: GetTokenResponse.self,
                        parameters: [
                            "phone": row1.textField.text!,
                            "code": row2.textField.text!,
                            "openid": openid,
                            "nickName": nickName,
                            "headimage": headimage
                        ]) { result, model, msg in
            if let model = model {
                UserDefaults.standard.set(model.token, forKey: "gToken")
                gToken = model.token
                self.dismiss(animated: true)
            }
        }
        
    }
    @IBAction func save() {
        if phone.isEmpty {
            bindPhone()
            return
        }
//        guard !row2.textField.text!.isEmpty else {
//            return
//        }
//        guard !row3.textField.text!.isEmpty else {
//            return
//        }
//        guard row3.textField.text! == row4.textField.text! else {
//            return
//        }
        if pwd {
            NetWork.request(.updatePassword,
                            modelType: NoneResponseData.self,
                            parameters: ["phone": row1.textField.text!, "code": row2.textField.text!, "password": row3.textField.text!]) { result, model, msg in
                if let _ = model {
                    Toast(text: "修改成功", duration: 0.5).show()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            NetWork.request(.updatePhone,
                            modelType: NoneResponseData.self,
                            parameters: ["phone": row3.textField.text!, "code": row2.textField.text!]) { result, model, msg in
                if let _ = model {
                    Toast(text: "修改成功", duration: 0.5).show()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
