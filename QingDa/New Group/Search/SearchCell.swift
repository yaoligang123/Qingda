//
//  SearchCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/15.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var tagListView:TagListView!
    @IBOutlet weak var select:UIButton!
    @IBOutlet weak var record:UILabel!
    @IBOutlet weak var buy:UILabel!
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
    
    func config(_ data:GetSearchCourseItem) {
        name.text = data.name
        thumbnail.load(data.thumbnail)
        tagListView.removeAllTags()
        tagListView.addTags([data.suject, getGrade(data.grade, data.semester), data.edition, data.years].filterEmpty())
        buy.isHidden = data.ifBuy != 1
        
        category.isHidden = false
        categoryBg.isHidden = false
        
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
    
    func config(_ data:GetStudyRecordListItem) {
        name.text = data.name
        thumbnail.load(data.thumbnail)
        tagListView.removeAllTags()
        tagListView.addTags([data.suject, getGrade(data.grade, data.semester), data.edition, data.years])
        record.text = "已学习：" + data.directoryName + "/" + data.studyName
    }
    
    func config(_ data:GetMyCourseItem) {
        name.text = data.objectName
        thumbnail.load(data.thumbnail)
        tagListView.removeAllTags()
        tagListView.addTags([data.objectJson.suject, getGrade(data.objectJson.grade, data.objectJson.semester), data.objectJson.edition, data.objectJson.years].filterEmpty())
        
        category.isHidden = false
        categoryBg.isHidden = false
        
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
        tagListView.addTags([data.suject, getGrade(data.grade, data.semester), data.edition, data.years].filterEmpty())
        select.isSelected = data.select
        buy.isHidden = data.ifHave != "1"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16))
    }
    
}
