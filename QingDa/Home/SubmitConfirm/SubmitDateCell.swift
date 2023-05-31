//
//  SubmitDateCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/18.
//

import UIKit

class SubmitDateCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var picker: UIDatePicker!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        picker.backgroundColor = .yellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
