//
//  PaperCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/26.
//

import UIKit

class PaperCell: UITableViewCell {
    
    @IBOutlet weak var subscrbe: UILabel!
    @IBOutlet weak var free: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tagListView:TagListView!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16))
    }
    
    func config(_ data: GetPaperListItem) {
        name.text = data.name
        tagListView.removeAllTags()
        tagListView.addTags([data.paperType == "1" ? "选题" : "PDF文件"])
        
        free.isHidden = true
        if Double(data.price) ?? 0 == 0 {
            subscrbe.text = ""
            free.isHidden = false
        } else if data.ifSubscribe == "1" {
            subscrbe.text = "已订阅"
        } else {
            subscrbe.text = ""
        }
        subscrbe.isHidden = subscrbe.text!.isEmpty
    }
}
