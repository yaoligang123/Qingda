//
//  ServiceApplyRow.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/28.
//

import UIKit

class ServiceApplyRow: CommonView {
    
    var tapAction: (() -> Void)? = nil
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBAction
    func tap() {
        self.tapAction?()
    }
}
