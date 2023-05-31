//
//  RefundImgCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/4/2.
//

import UIKit

class RefundImgCell: UICollectionViewCell {
    
    @IBOutlet weak var add:UIButton!
    @IBOutlet weak var close:UIButton!
    @IBOutlet weak var imageView:UIImageView!
    
    var tapAdd: (() -> Void)? = nil
    var tapClose: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addAction() {
        self.tapAdd?()
    }
    
    @IBAction func closeAction() {
        self.tapClose?()
    }
}
