//
//  OrdCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import UIKit

class OrdCell: UITableViewCell {
    @IBOutlet weak var orderNumber:UILabel!
    @IBOutlet weak var thumbnail:UIImageView!
    @IBOutlet weak var objectName:UILabel!
    @IBOutlet weak var price:UILabel!
    @IBOutlet weak var createTime:UILabel!
    @IBOutlet weak var tagListView: TagListView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16))
    }
    
    func config(_ data: GetMyOrderCourseListItem) {
        createTime.text = data.createTime
        orderNumber.text = "订单编号：\(data.orderNumber)"
        thumbnail.load(data.thumbnail)
        objectName.text = data.objectName
        price.text = data.source == "1" && Double(data.price) ?? 0 > 0 ? "¥\(data.price)" : "免费/会员选购"
        tagListView.removeAllTags()
        let json = data.objectJson
        tagListView.addTags([json.suject, getGrade(json.grade, json.semester), json.edition, json.years].filterEmpty())
    }
}
