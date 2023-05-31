//
//  SearchBar.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

class SearchBar: CommonView {
    
    var searchAction: ((String) -> Void)? = nil
    @IBOutlet weak var textField: UITextField!

    @IBAction
    func tapSearch() {
        searchAction?(textField.text ?? "")
    }
}
