//
//  DownloadCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/22.
//

import UIKit

class DownloadCell: UITableViewCell {
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var downType: UILabel!
    @IBOutlet weak var createTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ data: GetMyDownItem) {
//        category.text = data.category == "4" ? "组卷" : "错题"
        category.text = data.name
        amount.text = data.amount
        downType.text = data.downType == "1" ? "题目加答案" : "仅题目"
        createTime.text = data.createTime
    }
    
}
