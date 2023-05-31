//
//  MeViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/23.
//

//我的
//https://lanhuapp.com/web/#/item/project/detailDetach?pid=8da277bb-b578-457d-8447-279fc9448973&image_id=b0470ba1-396a-43a2-acd2-ba1364485990&tid=8406d474-88a1-48d5-8ebd-97ecaa111f9d&project_id=8da277bb-b578-457d-8447-279fc9448973&fromEditor=true&type=image

import UIKit

class MeViewController: UIViewController {
    
    var user: GetUserMessageUser?
    @IBOutlet weak var section1: MeSection!
    @IBOutlet weak var section2: MeSection!
    @IBOutlet weak var section3: MeSection!
    @IBOutlet weak var section4: MeSection!
    @IBOutlet weak var cell1: MeCell!
    @IBOutlet weak var cell2: MeCell!
    @IBOutlet weak var cell3: MeCell!
    @IBOutlet weak var cell4: MeCell!
    @IBOutlet weak var cell5: MeCell!
    @IBOutlet weak var cell6: MeCell!
    @IBOutlet weak var cell7: MeCell!
    @IBOutlet weak var cell8: MeCell!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var vipLabel: UILabel!
    @IBOutlet weak var study: UILabel!
    var vipOrder: VipOrder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 164)
        gradient.colors = [HEX("#FDECD9").cgColor, HEX("FEF4E8").cgColor, HEX("F7F7F7").cgColor]
        gradient.locations = [0, 0.57, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        section1.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.studyRecord, from: self)
        }
        
        section2.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.Download, from: self)
        }
        
        section3.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.MyClass(type: 1), from: self)
        }
        
        section4.tapAction = { [weak self] in
            guard let self = self else { return }
            self.goVip2()
        }
        
        cell1.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.Order, from: self)
        }
        
        cell2.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.Coupon, from: self)
        }
        
        cell3.tapAction = { [weak self] in
            guard let self = self else { return }
            self.customerService()
        }
        
        cell4.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.Promote, from: self)
        }
        
        cell5.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.Doc(type: "1"), from: self)
        }
        
        cell6.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.Doc(type: "3"), from: self)
        }
        
        cell7.tapAction = { [weak self] in
            guard let self = self else { return }
            self.logout()
        }
        
        cell8.tapAction = { [weak self] in
            guard let self = self else { return }
            self.kill()
        }
    }
    
    func customerService() {
        if WXApi.isWXAppInstalled() {
             let rep = WXOpenCustomerServiceReq()
             //这两个参数 可以照抄 第一个是固定的，第二个随意写
             rep.corpid = "wwca0150e67bdbe32a"
             rep.url = "https://work.weixin.qq.com/kfid/kfc2364c970f8a0bccf"
             WXApi.send(rep, completion: nil)

        }
    }
    
    func logout() {
        let menu = UIAlertController(title: nil, message: "确定退出登录?", preferredStyle: .alert)
        let unReceive = UIAlertAction(title: "取消", style: .default) { _ in
            
        }
        unReceive.setValue(UIColor.black, forKey: "_titleTextColor")
        let receive = UIAlertAction(title: "确认", style: .default) { [weak self] _ in
            guard let _ = self else { return }
            gToken = nil
            UserDefaults.standard.set("", forKey: "gToken")
            gTab?.selectedIndex = 0
        }
        receive.setValue(HEX(kMainColor1), forKey: "_titleTextColor")
        
        menu.addAction(unReceive)
        menu.addAction(receive)
        self.present(menu, animated: true, completion: nil)
    }
    
    func kill() {
        let menu = UIAlertController(title: nil, message: "注销账户信息将会全部删除，\r是否确认注销账号？", preferredStyle: .alert)
        let unReceive = UIAlertAction(title: "取消", style: .default) { _ in
            
        }
        unReceive.setValue(UIColor.black, forKey: "_titleTextColor")
        let receive = UIAlertAction(title: "确认", style: .default) { [weak self] _ in
            guard let _ = self else { return }
            
            NetWork.request(.killMe,
                            modelType: NoneResponseData.self,
                            parameters: [:]) { result, model, msg in
                if let _ = model {
                    gToken = nil
                    UserDefaults.standard.set("", forKey: "gToken")
                    gTab?.selectedIndex = 0
                    self?.profile.image = UIImage(named: "组 53611");
                }
            }
        }
        receive.setValue(HEX(kMainColor1), forKey: "_titleTextColor")
        
        menu.addAction(unReceive)
        menu.addAction(receive)
        self.present(menu, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserMessage()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func getUserMessage() {
        NetWork.request(.getUserMessage,
                        modelType: GetUserMessageResponse.self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.configData(model.user)
                if let vipOrder = model.vipOrder {
                    self.vipOrder = vipOrder
                    self.vipLabel.text = "\(vipOrder.sysName)，可免费订阅教辅数量\(vipOrder.sysAmount)/\(vipOrder.sysAmount)"
                }
            }
        }
    }
    
    func configData(_ data: GetUserMessageUser) {
        user = data
        nickNameLabel.text = data.nickName
        gradeLabel.text = [gGrade ?? "", gProvince ?? "", gCity ?? ""].filter{ !$0.isEmpty }.joined(separator: " ");
        profile.load(data.headimage, placeholder: UIImage(named: "组 53611"))
        study.text = "累计学习时长：\(Int(data.studyTimeCount / 60))分钟"
    }
    
    @IBAction func goSet() {
        Router.push(.MyInfo(type: 0), from: self)
    }
    
    func goVip2() {
        Router.push(.Vip, from: self)
    }
    
    @IBAction func goVip() {
        if let vipOrder = vipOrder {
            Router.push(.MyVip, from: self)
//            Router.push(.MyVipDetail(orderNumber: vipOrder.orderNumber), from: self)
        } else {
            Router.push(.Vip, from: self)
        }
    }
}
