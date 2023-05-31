//
//  JiaoFuCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/21.
//

import UIKit

struct JiaoFuCellData: Codable {
    var name: String
    var thumbnail: String
    var courseId: String
    var category: String
    var tags: [String]
}

class JiaoFuCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var tagListView:TagListView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var categoryBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let maskPath = UIBezierPath(roundedRect: categoryBg.bounds,
                                    byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.bottomLeft],
                                    cornerRadii: CGSize(width: 6, height: 6))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = categoryBg.bounds
        maskLayer.path = maskPath.cgPath
        categoryBg.layer.mask = maskLayer
    }
    
    func config(_ data:JiaoFuCellData) {
        name.text = data.name
        thumbnail.load(data.thumbnail)
        tagListView.removeAllTags()
        tagListView.addTags(data.tags)
        if data.category == "1" {
            category.text = "教材"
            let bgLayer1 = CAGradientLayer()
            bgLayer1.colors = [HEX("#8CFAA0").cgColor, HEX("#1FB33A").cgColor]
            bgLayer1.locations = [0, 1]
            bgLayer1.frame = category.bounds
            bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
            bgLayer1.endPoint = CGPoint(x: 0.54, y: 0.54)
            categoryBg.layer.addSublayer(bgLayer1)
        } else {
            category.text = "教辅"
            let bgLayer1 = CAGradientLayer()
            bgLayer1.colors = [HEX("#8EB7FE").cgColor, HEX("#347FFF").cgColor]
            bgLayer1.locations = [0, 1]
            bgLayer1.frame = category.bounds
            bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
            bgLayer1.endPoint = CGPoint(x: 0.54, y: 0.54)
            categoryBg.layer.addSublayer(bgLayer1)
        }
    }
    
    func config(_ data:SysVipDetilsJson) {
        name.text = data.name
        thumbnail.load(data.thumbnail)
        tagListView.removeAllTags()
        tagListView.addTags([data.suject, getGrade(data.grade, data.semester)].filterEmpty())
        
        if data.category == "1" {
            category.text = "教材"
            let bgLayer1 = CAGradientLayer()
            bgLayer1.colors = [HEX("#8CFAA0").cgColor, HEX("#1FB33A").cgColor]
            bgLayer1.locations = [0, 1]
            bgLayer1.frame = category.bounds
            bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
            bgLayer1.endPoint = CGPoint(x: 0.54, y: 0.54)
            categoryBg.layer.addSublayer(bgLayer1)
        } else {
            category.text = "教辅"
            let bgLayer1 = CAGradientLayer()
            bgLayer1.colors = [HEX("#8EB7FE").cgColor, HEX("#347FFF").cgColor]
            bgLayer1.locations = [0, 1]
            bgLayer1.frame = category.bounds
            bgLayer1.startPoint = CGPoint(x: 0, y: 0.5)
            bgLayer1.endPoint = CGPoint(x: 0.54, y: 0.54)
            categoryBg.layer.addSublayer(bgLayer1)
        }
    }
}
