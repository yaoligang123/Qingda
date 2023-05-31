//
//  WebCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import UIKit
import WebKit

class WebCell: UITableViewCell {

    @IBOutlet weak var web: WKWebView!
    
    func config(content: String) {
        web.loadHTMLString(content, baseURL: nil)
    }
}
