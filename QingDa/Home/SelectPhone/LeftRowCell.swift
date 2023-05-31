//
//  LeftRowCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class LeftRowCell: UITableViewCell {
    
    var select: Bool = false {
        didSet {
            if select {
                title.textColor = HEX("#4AA6FB")
                contentView.backgroundColor = .white
                line.isHidden = false
            } else {
                title.textColor = HEX("#333333")
                contentView.backgroundColor = HEX("#F7F7F7")
                line.isHidden = true
            }
        }
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var line: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
