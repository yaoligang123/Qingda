//
//  SelHeader.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/22.
//

import UIKit

class SelHeader: UICollectionReusableView {
    @IBOutlet weak var name: UILabel!
    
    func config(_ data:PopSelItem) {
        name.text = data.title
    }
}
