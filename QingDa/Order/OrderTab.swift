//
//  OrderTab.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/3.
//

import UIKit

class OrderTab: CommonView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var line: UIView!
    var tapAction: (() -> Void)? = nil
    var select:Bool = false {
        didSet {
            title.textColor = select ? .black : HEX("#999999")
            line.isHidden = !select
        }
    }

    @IBAction func tap() {
        tapAction?()
    }
}
