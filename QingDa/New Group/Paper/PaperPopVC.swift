//
//  PaperPopVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/7.
//

import UIKit

class PaperPopVC: UIViewController {
    
    var name: String = ""
    var price: String = ""
    var tapAction: (() -> Void)? = nil
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .overFullScreen
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        nameLabel.text = name
        priceLabel.text = "¥\(price)"
    }
    
    @IBAction func confirm() {
        tapAction?()
        close()
    }
    
    @IBAction func close() {
        self.dismiss(animated: false);
    }
}
