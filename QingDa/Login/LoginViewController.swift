//
//  LoginViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class LoginViewController: UIViewController {
    
    let countDownNum = 60
    var account = ""
    @IBOutlet weak var selectView: SelectView!
    @IBOutlet weak var phoneLabel: LineTextField!
    @IBOutlet weak var codeLabel: LineTextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var countBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setUI() {
        self.title = "Sign in"
        changeBtnState()
        selectView.selectChange = { [weak self] in
            guard let self = self else { return }
            self.changeBtnState()
        }
        phoneLabel.keyboardType = .phonePad
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startCount() {
        guard let phone = phoneLabel.text, !phone.isEmpty else { return }
        account = phone
        let dic = ["phone" : account]
        startLoading()
        NetWork.request(.sendCode,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                
            }
            self.stopLoading()
        }
        
        let date = Date().timeIntervalSince1970
        countBtn.isHidden = true
        self.countLabel.text = String(countDownNum) + "s"
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let differ = self.countDownNum - Int(floor(Date().timeIntervalSince1970 - date))
            if differ <= 0 {
                self.countLabel.text = "Código de verificação"
                self.countBtn.isHidden = false
                timer.invalidate()
            } else {
                self.countLabel.text = String(differ) + "s"
            }
        }
    }
    
    @IBAction func textFieldChange(_ textField:UITextField) {
        changeBtnState()
    }
    
    func changeBtnState() {
        if let phone = phoneLabel.text,
           let code = codeLabel.text {
            confirmBtn.isEnabled = phone.count > 0 && code.count > 0 && selectView.select
        } else {
            confirmBtn.isEnabled = false
        }
        confirmBtn.backgroundColor = confirmBtn.isEnabled ? HEX(kMainColor1) :  HEX(kSubColor4)
        
        titleLabel.text = confirmBtn.isEnabled ? "Bem-vindos ao\nConserto de Celular." : "seja bem-vindo\na assistência técnica de celulares"
    }
    
    @IBAction func login() {
        guard let code = codeLabel.text, !code.isEmpty, !account.isEmpty else { return }
        let dic = ["account": account, "code" : code]
        startLoading()
        NetWork.request(.login,
                        modelType: GetLoginData.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                UserDefaults.standard.set(model.token, forKey: "gToken")
                gToken = model.token
                self.close()
            }
            self.stopLoading()
        }
    }
}
