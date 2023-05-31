//
//  MyItemSection.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class MyItemSection: CommonView {
    
    var tapAction: (() -> ())? = nil
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction
    func tap() {
        self.tapAction?()
    }
}
