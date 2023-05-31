//
//  HomeTechCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/2.
//

import UIKit
import Alamofire

class HomeTechCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ data: StudyData) {
        title.text = data.title + data.title
        icon.load(data.thumbnail)
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: data.updateDate)
        formatter.dateFormat = "dd - MM - yyyy"
        if let date = date {
            time.text = formatter.string(from: date)
        } else {
            time.text = ""
        }
    }
}
