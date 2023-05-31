//
//  ProductView.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/2.
//

import UIKit

struct ProductViewData {
    var thumbnail: String
    var price: Double
    var title: String
    var sale: Int
    
    static func convert(data: GetProductByTypeRecordResponse) -> Self {
        ProductViewData(thumbnail: data.thumbnail,
                        price: data.price,
                        title: data.title,
                        sale: 0)
    }
}

class ProductView: CommonView {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sale: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func config(data: ProductViewData) {
        thumbnail.load(data.thumbnail)
        price.text = "¥\(data.price)"
        title.text = data.title
        sale.text = "销量\(data.sale)"
    }
}
