//
//  LoginVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/7.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var phoneLabel: LineTextField!
    @IBOutlet weak var codeLabel: LineTextField!
    @IBOutlet weak var wording: UIButton!
    @IBOutlet weak var getCode: UIButton!
    @IBOutlet weak var codeRow: UIView!
    @IBOutlet weak var codeImage: UIImageView!
    @IBOutlet weak var height: NSLayoutConstraint!
    var code = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: self.view.bounds.height)
        gradient.colors = [HEX("#FCE8D8").cgColor, HEX("#F9FFFD").cgColor, UIColor.white.cgColor]
        gradient.locations = [0, 0.66, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func textChange() {
//        codeRow.isHidden = false
//        codeRow.isHidden = phoneLabel.text!.count != 11
    }
    
    @IBAction func login() {
        if code {
            appLoginByPhone()
        } else {
            appLoginByPassword()
        }
    }
    
    @IBAction func pwd() {
        code = !code
        
        if code {
            wording.setTitle("密码登录", for: .normal);
            phoneLabel.placeholder = "请输入手机号"
            codeLabel.placeholder = "请输入验证码"
            getCode.isHidden = false
            codeImage.isHidden = false
            label1.isHidden = true
            label2.isHidden = true
            height.constant = 40
        } else {
            wording.setTitle("验证码登录", for: .normal);
            phoneLabel.placeholder = "请输入账号"
            codeLabel.placeholder = "请输入密码"
            getCode.isHidden = true
            codeImage.isHidden = true
            label1.isHidden = false
            label2.isHidden = false
            height.constant = 0
        }
    }
    
    @IBAction func weChat() {
        if WXApi.isWXAppInstalled() {
             let rep = SendAuthReq()
             //这两个参数 可以照抄 第一个是固定的，第二个随意写
             rep.scope = "snsapi_userinfo"
             rep.state = "wx_oauth_authorization_state"
             WXApi.send(rep, completion: nil)
        }
    }
    
    @IBAction func sendCode() {
        NetWork.request(.sendCode,
                        modelType: String.self,
                        parameters: ["category": "1", "phone": phoneLabel.text!]) { result, model, msg in
            if let model = model {
                self.codeLabel.text = model
            }
        }
    }
    
    func appLoginByPhone() {
        NetWork.request(.appLoginByPhone,
                        modelType: GetLoginData.self,
                        parameters: ["code": codeLabel.text!, "phone": phoneLabel.text!]) { result, model, msg in
            if let model = model {
                self.dismiss(animated: true)
                UserDefaults.standard.set(model.token, forKey: "gToken")
                gToken = model.token
            }
        }
    }
    
    func appLoginByPassword() {
        NetWork.request(.appLoginByPassword,
                        modelType: GetLoginData.self,
                        parameters: ["password": codeLabel.text!, "phone": phoneLabel.text!]) { result, model, msg in
            if let model = model {
                self.dismiss(animated: true)
                UserDefaults.standard.set(model.token, forKey: "gToken")
                gToken = model.token
            }
        }
    }
}

