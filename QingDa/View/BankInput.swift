//
//  BankInput.swift
//  PhoneRepair
//
//  Created by develop on 2022/4/20.
//

import UIKit

class BankInput: CommonView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var input: UITextField!
    var textFieldChangeAction: (() -> Void)? = nil
    var tapAction: (() -> Void)? = nil
    
    @IBAction func textFieldChange(_ textField:UITextField) {
        textFieldChangeAction?()
    }
    
    override func commonInit() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc
    func tap() {
        self.tapAction?()
    }
}
