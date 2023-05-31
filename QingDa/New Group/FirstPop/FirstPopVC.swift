//
//  FirstPopVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/28.
//

import UIKit

class FirstPopVC: UIViewController {
    @IBOutlet weak var gradeBtn: UIButton!
    @IBOutlet weak var areaBtn: UIButton!
    var grade: String?
    var province: String?
    var city: String?
    var tapAction: (() -> Void)? = nil
    
    var sels = [PopSel(title: "年级", type: .grade),
                PopSel(title: "地区", type: .city)];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .overFullScreen
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
    }
    
    @IBAction func tapSelector(btn: UIButton) {
        let vc = PopSelVC()
        vc.sels = sels.clone()
        vc.selectedIndex = btn.tag
        vc.tapAction = {  [weak self] in
            guard let self = self else { return }
            self.sels = $0
            self.update()
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    func update() {
        let grade = sels[0]
        if (grade.selectedRow >= 0) {
            let first = grade.item[grade.selectedRow]
            let grade = first.children[first.selectedRow].title
            gradeBtn.setTitle(grade, for: .normal)
            self.grade = grade
        }
        
        let city = sels[1]
        if (city.selectedRow >= 0 && city.item[city.selectedRow].selectedRow >= 0) {
            let first = city.item[city.selectedRow]
            let province = first.title
            let city = first.children[first.selectedRow].title
            if !province.isEmpty && !city.isEmpty {
                areaBtn.setTitle(province + city, for: .normal)
                self.province = province
                self.city = city
            }
        }
    }
    
    @IBAction func confirm() {
        if let grade = grade, let province = province, let city = city {
            saveGrade(grade)
            saveProvince(province)
            saveCity(city)
            tapAction?()
            self.dismiss(animated: false);
        }
    }
}
