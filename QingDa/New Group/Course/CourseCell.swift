//
//  CourseCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/27.
//

import UIKit

class CourseCell: UITableViewCell {
    @IBOutlet weak var no:UILabel!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var category:UILabel!
    @IBOutlet weak var studyBili:UILabel!
    
    func config(_ index: String, _ data: GetCourseDetilsItem,_ ifBuy: Int) {
        no.text = index
        name.text = data.name
        category.text = data.category == "1" ? "视频" : "图文"
        
        if data.videoUrl.isEmpty {
            studyBili.text = "未更新"
        } else if data.ifStudy != "0" {
            studyBili.text = (ifBuy > 0 ? "已学" : "已试学") + data.studyBili + "%"
        } else {
            studyBili.text = ""
        }
    }
}
