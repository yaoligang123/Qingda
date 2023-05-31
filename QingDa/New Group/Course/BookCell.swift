//
//  BookCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/16.
//

import UIKit

class BookCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var readLabel: UILabel!
    
    func config(_ url: String, radius: Double = 4, selected: Bool = false, read: Bool = false) {
        image.layer.cornerRadius = radius
        image.load(url)
        image.layer.borderWidth = selected ? 1 : 0
        image.layer.borderColor = HEX(kMainColor1).cgColor
        readLabel.isHidden = !read
    }
}
