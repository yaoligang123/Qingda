//
//  SubmitInfoCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/27.
//

import UIKit

class SubmitInfoCell: UITableViewCell {
    
    var model: GetRepairModelDetilsData?
    var tapAction: (() -> Void)? = nil
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ model: GetRepairModelDetilsData, index:Int) {
        self.model = model
        title.text = String(index + 1) + "、" + model.title
        
        stackView.removeAll()
        
        for (index, option) in model.optionJson.enumerated() {
            let btn = UIButton.init(type: .custom)
            btn.backgroundColor = index == model.row ? HEX(kMainColor1) : HEX(kSubColor4)
            btn.layer.cornerRadius = 8
            btn.layer.masksToBounds = true
            btn.setTitle(option.optiona, for: .normal)
            btn.setTitleColor(index == model.row ? .white : HEX(kMainColor2), for: .normal)
            btn.titleLabel?.font = UIFont.init(name: ".PingFang SC", size: 14)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.heightAnchor.constraint(equalToConstant: 48).isActive = true
            btn.tag = index
            btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
            stackView.addArrangedSubview(btn)
        }
    }
    
    @objc
    func tap(btn:UIButton){
        guard let model = model else { return }
        model.row = model.row == btn.tag ? -1 : btn.tag
        tapAction?()
    }
}
