//
//  FalseBookCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/26.
//

import UIKit

class FalseBookCell: UICollectionViewCell {
    
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var suject: UILabel!
    @IBOutlet weak var sujectCount: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    func config(_ data: GetErrorBookSujectCountResponse) {
        suject.text = data.suject
        sujectCount.text = data.sujectCount + "题"
        
        shadow.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        shadow.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadow.layer.shadowOpacity = 1
        shadow.layer.shadowRadius = 7
        image.image = IMAGE(data.image)
    }
}
