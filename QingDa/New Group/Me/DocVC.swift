//
//  DocVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/9.
//

import UIKit

class DocVC: UIViewController {
    
    var type = ""
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if type == "1" {
            title = "隐私协议"
        } else if type == "3" {
            title = "服务政策"
        }
        
        getDoc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func getDoc() {
        NetWork.request(.getSys,
                        modelType: GetSysResponse.self,
                        parameters: ["category": type]) { result, model, msg in
            if let model = model {
                self.textView.text = model.content
            }
        }
    }
}
