//
//  CourseHeader.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/27.
//

import UIKit

class CourseHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var read:UILabel!
    @IBOutlet weak var arrow:UIImageView!
    var tapAction: (() -> Void)? = nil
    
    var selected: Bool = false {
        didSet {
            arrow.image = IMAGE(selected ? "组 61093" : "组 61093(1)")
        }
    }
    
    @IBAction func tap() {
        self.tapAction?()
    }
}
