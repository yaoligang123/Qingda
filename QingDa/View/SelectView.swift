//
//  SelectView.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/13.
//

import UIKit

class SelectView: CommonView {
    var select = false
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var title: UILabel!
    var selectChange: (() -> Void)? = nil
    
    @IBAction
    func selectAction() {
        select = !select
        btn.isSelected = select
        selectChange?()
    }
}
