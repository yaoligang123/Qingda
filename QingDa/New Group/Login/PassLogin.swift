//
//  PassLogin.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/7.
//

import UIKit

class PassLogin: UIViewController {
    
    @IBOutlet weak var phoneLabel: LineTextField!
    @IBOutlet weak var codeLabel: LineTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [HEX("#FCE8D8").cgColor, HEX("#F9FFFD").cgColor, UIColor.white.cgColor]
        gradient.locations = [0, 0.66, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
}
