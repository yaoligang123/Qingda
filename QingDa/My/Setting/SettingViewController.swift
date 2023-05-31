//
//  SettingViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=96ddd8d9-1873-4fd0-b5f2-60802148483d&fromEditor=true

import UIKit
import Kingfisher

class SettingViewController: UIViewController, UINavigationControllerDelegate {
    
    var userData: GetUserMessageData?
    var uploadImage: String = ""
    
    @IBOutlet weak var row1: SettingRow!
    @IBOutlet weak var row2: SettingRow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setUI() {
        self.title = "Configuração"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        row1.imageView.isHidden = false
        row1.imageView.backgroundColor = .white
        row1.imageView.layer.masksToBounds = true
        row1.imageView.layer.cornerRadius = 21
        row1.textField.isUserInteractionEnabled = false
        row1.tapAction = { [weak self] in
            guard let self = self else { return }
            PhotoLib.shared.showPhotoLib(self) { [weak self] (data, url) in
                guard let self = self else { return }
                self.uploadImage = url
                self.row1.imageView.image = data
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Salvar", style: .plain, target: self, action: #selector(confirm))
        
        if let userData = userData {
            row1.imageView.load(userData.headimage, placeholder: UIImage(named: "组 56509"))
            row2.textField.text = userData.name
        }
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func confirm() {
        updateUserMessage()
    }
    
    func updateUserMessage() {
        if let name = row2.textField.text, !name.isEmpty {
            var dic:[String: String] = ["name": name]
            
            if !uploadImage.isEmpty {
                dic["headimage"] = uploadImage
            }
                                        
            startLoading()
            NetWork.request(.updateUserMessage,
                            modelType: NoneResponseData.self,
                            parameters: dic) { result, model, msg in
                if let _ = model {
                    self.pop()
                }
                self.stopLoading()
            }
        }
    }
}
