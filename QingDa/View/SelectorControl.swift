//
//  SelectorControl.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/15.
//

import UIKit

class SelectorControl: CommonView {
    var select: ((Int) -> Void)? = nil
    private var buttonTitles:[String] = []
    var buttons: [Selector] = []
    
    @IBOutlet weak var stackView: UIStackView!
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    private func updateView() {
        createButton()
    }
    
    private func createButton() {
        stackView.removeAll();
        buttons = [Selector]()
        buttons.removeAll()
        var index = 0
        for buttonTitle in buttonTitles {
            let button = Selector()
            button.title = buttonTitle
            buttons.append(button)
            button.tag = index
            stackView.addArrangedSubview(button)
            index = index + 1
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(tab))
            button.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func tab(sender: UITapGestureRecognizer) {
        select?(sender.view?.tag ?? 0)
    }
}
