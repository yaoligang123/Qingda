//
//  MyViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/19.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=50e0a2c4-1b00-4dd2-ac27-70efbe0940f1&fromEditor=true

import UIKit
import Kingfisher

class MyViewController: UIViewController {
    
    var userData: GetUserMessageData? {
        didSet {
            if let userData = userData {
                nameLabel.text = userData.name
                subLabel.text = "Seja bem-vindo a assistência técnica de celulares."
                
                profile.load(userData.headimage, placeholder: UIImage(named: "组 56509"))
            } else {
                nameLabel.text = "Entrar/Registo"
                subLabel.text = "Por favor, faça login"
                profile.image = UIImage(named: "组 56509")
            }
        }
    }
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var logOut: UIButton!
    
    @IBOutlet weak var section1: MyItemSection!
    @IBOutlet weak var section2: MyItemSection!
    @IBOutlet weak var section3: MyItemSection!
    @IBOutlet weak var section4: MyItemSection!
    @IBOutlet weak var section5: MyItemSection!
    
    @IBOutlet weak var row1: MyItemRow!
    @IBOutlet weak var row2: MyItemRow!
    @IBOutlet weak var row3: MyItemRow!
    
    let itemTitle = ["Aguardando\rpagamento", "Aguardando\ro envio", "Aguardando\ro recebimento", "Concluído", "Pós-venda"]
    let itemIcon = ["组 57016", "组 57017", "组 57053", "组 57019", "组 57020"]
    
    let rowTitle = ["Pós-venda", "Serviço de atendimento", "Sobre nós"]
    let rowIcon = ["组 57004", "组 57005", "组 57006"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        getUserMessage()
        
        logOut.isHidden = !isLogin()
        if !isLogin() {
            self.userData = nil
        }
    }
    
    func setUI() {
        let rows = [row1, row2, row3]
        for (i, row) in rows.enumerated() {
            row?.title.text = rowTitle[i]
            row?.icon.image = IMAGE(rowIcon[i])
        }
        
        let sections = [section1, section2, section3, section4, section5]
        for (i, item) in sections.enumerated() {
            item?.title.text = itemTitle[i]
            item?.icon.image = IMAGE(itemIcon[i])
            item?.tapAction = { [weak self] in
                gTab?.selectedIndex = 1
                if let vc = gOrder {
                    vc.fromMe = true
                    vc.tagProduct = i + 1
                }
            }
        }
        
        row1.tapAction = { [weak self] in
            guard let self = self else { return }
//            Router.push(.AddressList(action: nil), from: self)
        }
        
        row2.tapAction = { [weak self] in
            tel()
        }
        
        row3.tapAction = { [weak self] in
            guard let self = self else { return }
//            Router.push(.Web, from: self)
        }
    }
    
    @IBAction func tapProfile() {
        if userData == nil {
            Router.present(.Login, from: self)
        }
    }
    
    @IBAction func tapSetting() {
        guard let user = userData else {
            Router.present(.Login, from: self)
            return
        }
        Router.push(.Setting(userData: user), from: self)
    }
    
    func getUserMessage() {
        guard isLogin() else { return }
        NetWork.request(.getUserMessage,
                        modelType:GetUserMessageData.self) { result, model, msg in
            if let model = model {
                self.userData = model
            }
        }
    }
    
    @IBAction func logout() {
        startLoading()
        NetWork.request(.quit,
                        modelType: GetLoginData.self,
                        parameters: [:]) { result, model, msg in
            UserDefaults.standard.set("", forKey: "gToken")
            gToken = nil
            self.userData = nil
            self.logOut.isHidden = true
            self.stopLoading()
        }
    }
}

