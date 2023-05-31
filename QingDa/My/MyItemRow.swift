//
//  MyItemRow.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/23.
//

import UIKit

class MyItemRow: CommonView {
    
    var tapAction: (() -> ())? = nil
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBAction
    func tap() {
        self.tapAction?()
    }
}
