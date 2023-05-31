//
//  MessageCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/20.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var state: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(item: MessageListItem) {
        icon.image = IMAGE(item.category == "1" ? "组 61337" : "组 61336")
        message.text = item.message
        category.text = item.category == "1" ? "课程购买" : "课程更新"
        createTime.text = item.createTime.components(separatedBy: " ")[0]
        state.isHidden = item.state != "0"
    }
}
