//
//  CouponCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import UIKit

class CouponCell: UITableViewCell {
    
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var discountAmount:UILabel!
    @IBOutlet weak var disuseDate:UILabel!
    @IBOutlet weak var explains:UILabel!
    @IBOutlet weak var mask1:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))
    }
    
    func config(_ data: CouponResponse, _ index: Int) {
        name.text = data.name
        discountAmount.text = "¥\(data.discountAmount)"
        disuseDate.text = "有效期至：\(data.disuseDate)"
        explains.text = "使用说明：\(data.explains)"
        mask1.isHidden = index == 0
    }
    
}
