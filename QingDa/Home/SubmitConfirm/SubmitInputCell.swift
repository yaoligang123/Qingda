//
//  SubmitInputCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/27.
//

import UIKit

class SubmitInputCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var input: UITextField!
    var inputAction: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        input.addTarget(self, action: #selector(inputChange), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func inputChange() {
        self.inputAction?()
    }
}
