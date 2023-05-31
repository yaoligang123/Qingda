//
//  MyInfoViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/8.
//

import UIKit
import Toaster

class MyInfoViewController: UIViewController {
    
    var type: Int = 0
    var sels = [PopSel(title: "地区", type: .city),
        PopSel(title: "年级", type: .grade)]
    @IBOutlet weak var row1:SettingRow!
    @IBOutlet weak var row2:SettingRow!
    @IBOutlet weak var row3:SettingRow!
    @IBOutlet weak var row4:SettingRow!
    @IBOutlet weak var row5:SettingRow!
    @IBOutlet weak var row6:SettingRow!
    @IBOutlet weak var row7:SettingRow!
    
    @IBOutlet weak var save:UIButton!
    @IBOutlet weak var wechat:UIButton!
    var province = ""
    var city = ""
    var grade = ""
    var uploadImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserMessage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setUI() {
        self.title = "我的信息"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if type == 0 {
            let action: (() -> Void) = { [weak self] in
                self?.goEdit()
            }
            row1.tapAction = action
            row2.tapAction = action
            row3.tapAction = action
            row4.tapAction = action
            row5.tapAction = action
            
            save.isHidden = true
            wechat.isHidden = true
        }
        
        if type == 1 {
            row1.tapAction = { [weak self] in
                guard let self = self else { return }
                PhotoLib.shared.showPhotoLib(self) { [weak self] (data, url) in
                    guard let self = self else { return }
                    self.uploadImage = url
                    self.row1.profileImg.image = data
                }
            }
            row2.textField.isUserInteractionEnabled = true
            row3.tapAction = { [weak self] in
                self?.tapSelector(index: 0)
            }
            row4.tapAction = { [weak self] in
                self?.tapSelector(index: 1)
            }
            row5.textField.isUserInteractionEnabled = true
            row6.isHidden = true
            row7.isHidden = true
        }
        
        row6.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.ChangePhone(phone: self.row6.textField.text!, pwd: false), from: self)
        }
        row6.change.isUserInteractionEnabled = false
        
        row7.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.ChangePhone(phone: self.row6.textField.text!, pwd: true), from: self)
        }
        row7.change.isUserInteractionEnabled = false
        
    }
    
    func goEdit() {
        Router.push(.MyInfo(type: 1), from: self)
    }
    
    func tapSelector(index: Int) {
        let vc = PopSelVC()
        vc.sels = sels.clone()
        vc.selectedIndex = index
        vc.tapAction = {  [weak self] in
            guard let self = self else { return }
            self.sels = $0
            self.update()
        }
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
    
    func update() {
        let grade = sels[1]
        if (grade.selectedRow >= 0) {
            let first = grade.item[grade.selectedRow]
            let grade = first.children[first.selectedRow].title
            row4.textField.text = grade
            self.grade = grade
        }

        let city = sels[0]
        if (city.selectedRow >= 0 && city.item[city.selectedRow].selectedRow >= 0) {
            let first = city.item[city.selectedRow]
            let province = first.title
            let city = first.children[first.selectedRow].title
            if !province.isEmpty && !city.isEmpty {
                self.province = province
                self.city = city
                row3.textField.text = province + city
            }

        }
    }
    
    @IBAction func goSave() {
        var dic = [
            "nickName" : row2.textField.text!,
            "school" : row5.textField.text!
        ]
        if !uploadImage.isEmpty {
            dic["headimage"] = uploadImage
        }
        NetWork.request(.updateUserMessage,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                if !self.grade.isEmpty {
                    saveGrade(self.grade)
                }
                if !self.province.isEmpty {
                    saveProvince(self.province)
                    saveCity(self.city)
                }
                Toast(text: "保存成功", duration: 0.5).show()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getUserMessage() {
        NetWork.request(.getUserMessage,
                        modelType: GetUserMessageResponse.self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.configData(model.user)
            }
        }
    }
    
    func configData(_ data: GetUserMessageUser) {
        row1.profileImg.load(data.headimage)
        row2.textField.text = data.nickName
        row3.textField.text = (gProvince ?? "") + (gCity ?? "")
        row4.textField.text = gGrade
        row5.textField.text = data.school
        row6.textField.text = data.phone
    }
}
