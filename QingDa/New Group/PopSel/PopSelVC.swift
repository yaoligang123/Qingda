//
//  PopSelVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/30.
//

import UIKit

enum PopSelType: String {
    case subject = "8"
    case year = "10"
    case city = "14"
    case grade = "15"
    case exam = "100"
    case selection = "101"
    case edtion = "102"
}

class PopSel: Copying {
    required init(original: PopSel) {
        selectedRow = original.selectedRow
        title = original.title
        type = original.type
        item = original.item.clone()
    }
    
    var selectedRow: Int = -1
    var title: String = ""
    var type: PopSelType
    var item: [PopSelItem] = []
    
    init(title: String, type: PopSelType, item: [PopSelItem] = []) {
        self.type = type
        self.title = title
        self.item = item
    }
}

class PopSelItem: Copying {
    required init(original: PopSelItem) {
        selectedRow = original.selectedRow
        title = original.title
        children = original.children.clone()
    }
    
    var selectedRow: Int = -1
    var title: String = ""
    var children: [PopSelItem] = []
    
    init(title: String, children: [PopSelItem]) {
        self.children = children
        self.title = title
    }
}


class PopSelVC: UIViewController {
    var type: Int = 0
    var selectedIndex: Int = 0
    var tapAction: (([PopSel]) -> Void)? = nil
    var hasReset = false
    var hasSem = false
    
    @IBOutlet weak var resetBtn:UIButton!
    @IBOutlet weak var dismiss:UIView!
    @IBOutlet weak var bar:UIView!
    @IBOutlet weak var table1:UITableView!
    @IBOutlet weak var table2:UITableView!
    @IBOutlet weak var control:CustomSegmentedControl!
    @IBOutlet weak var selector: SelectorControl!
    
    @IBOutlet weak var tableStackView:UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var sels: [PopSel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .overFullScreen
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        resetBtn.setTitle(hasReset ? "重置" : "取消", for: .normal)
        table1.register(UITableViewCell.self, forCellReuseIdentifier: "cellID");
        table2.register(UITableViewCell.self, forCellReuseIdentifier: "cellID");
        
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(close))
//        dismiss.addGestureRecognizer(recognizer)
        
        if type == 0 {
            control.setButtonTitles(buttonTitles: sels.map { $0.title })
            control.setIndex(index: selectedIndex)
            control.delegate = self
            selector.isHidden = true
        } else {
            control.isHidden = true
            control.setButtonTitles(buttonTitles: [""])
            selector.setButtonTitles(buttonTitles: sels.map { $0.title })
            selector.select = { [weak self] index in
                guard let self = self else { return }
                self.change(to: index)
            }
        }
        
        change(to: selectedIndex)
        
        collectionView.register(UINib(nibName: "SelCell", bundle: nil), forCellWithReuseIdentifier: "SelCell")

        collectionView.register(UINib(nibName: "SelHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SelHeader")
        
    }
    
    @IBAction
    func close() {
        self.dismiss(animated: false)
    }
    
    @IBAction
    func reset() {
        let sel = sels[selectedIndex]
        
        
        
        if hasReset {
            if sel.type == .grade && hasSem {
                sel.item[0].selectedRow = -1
            }
            
            if sel.selectedRow >= 0 {
                sel.item[sel.selectedRow].selectedRow = -1
                sel.selectedRow = -1
            }
            
            select()
        } else {
            close()
        }
    }
    
    func getSys(_ sel: PopSel) {
        if sel.type == .edtion {
            let suject = sels[2]
            if (suject.selectedRow >= 0) {
                let first = suject.item[suject.selectedRow]
                NetWork.request(.getSujectRelation,
                                modelType: GetSujectRelationResponse.self,
                                parameters: ["suject": first.children[first.selectedRow].title]) { result, model, msg in
                    sel.item = model?.version.map({ item in
                        PopSelItem(title:item.name, children: [])
                    }) ?? []
                    self.update()
                }
                return
            }
            sel.item = []
            self.update()
            return
        }
        if sel.type == .exam {
            let types = ["月考", "期中", "期末", "中考真题", "中考模拟"]
            sel.item = types.map({ item in
                PopSelItem(title:item, children: [])
            })
            self.update()
            return
        }
        if sel.item.count > 0 {
            self.update()
            return
        }
        NetWork.request(.getSys,
                        modelType: [GetSysResponse].self,
                        parameters: ["category": sel.type.rawValue]) { result, model, msg in
            if let model = model {
                if (sel.type == .subject) {
                    sel.item =
                        [PopSelItem(title: "科目",
                                   children: model.map({ item in
                            PopSelItem(title:item.content, children: [])
                        }))]
                } else {
                    sel.item = model.map {
                        PopSelItem(title: $0.content,
                                   children: $0.children.map({ item in
                            PopSelItem(title:item.content, children: [])
                        }))
                    }
                }
                
                if (sel.type == .grade && self.hasSem) {
                    sel.item = [PopSelItem(title: "学期",
                                           children: [
                                            PopSelItem(title: "全学期",
                                                                   children: []),
                                            PopSelItem(title: "上学期",
                                                                   children: []),
                                            PopSelItem(title: "下学期",
                                                                   children: [])
                                           ])] + sel.item
                }
                
                self.update()
            }
        }
    }
    
    func isCollection(_ type: PopSelType) -> Bool {
        type == .grade || type == .subject
    }
    func update() {
        let sel = sels[selectedIndex]
        if (isCollection(sel.type)) {
            collectionView.reloadData()
        } else {
            table1.reloadData()
            table2.reloadData()
        }
    }
}

extension PopSelVC: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        selectedIndex = index
        let sel = sels[selectedIndex]
        if (sel.type == .selection) {
            control.isHidden = true
            heightConstraint.constant = 250
        }
        if (isCollection(sel.type)) {
            bar.isHidden  = true;
            collectionView.isHidden = false;
            tableStackView.isHidden = true;
        } else {
            bar.isHidden  = true;
            collectionView.isHidden = true;
            tableStackView.isHidden = false;
            if (sel.type == .city || sel.type == .selection) {
                table2.isHidden = false
            } else {
                table2.isHidden = true
            }
        }
        getSys(sels[index])
    }
}

extension PopSelVC: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sel = sels[selectedIndex]
        if (tableView == table1) {
            return sel.item.count
        } else if (tableView == table2 && !sel.item.isEmpty && sel.selectedRow >= 0) {
            return sel.item[sel.selectedRow].children.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var title = ""
        var isSelected = false
        let sel = sels[selectedIndex]
        if (tableView == table1 && indexPath.row < sel.item.count) {
            title = sel.item[indexPath.row].title
            isSelected = sel.selectedRow == indexPath.row
        } else if (tableView == table2) {
            let selectedRow = sel.selectedRow
            if selectedRow >= 0 && indexPath.row < sel.item[selectedRow].children.count {
                title = sel.item[selectedRow].children[indexPath.row].title
                isSelected = sel.item[selectedRow].selectedRow == indexPath.row
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = title
        cell.textLabel?.textColor = isSelected ? HEX(kMainColor1) : HEX(kMainColor2)
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sel = sels[selectedIndex]
        if (tableView == table1) {
            sel.selectedRow = indexPath.row
            if (sel.type != .city && sel.type != .selection) {
//                select()
            }
        } else if (tableView == table2) {
            let index = sels[selectedIndex].selectedRow
            sel.item[index].selectedRow = indexPath.row
//            select()
        }
        update()
    }
    
    @IBAction
    func select() {
        tapAction?(sels)
        close()
    }
}

extension PopSelVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SelHeader", for: indexPath) as! SelHeader
            let sel = sels[selectedIndex]
            header.config(sel.item[indexPath.section])
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelCell", for: indexPath) as! SelCell
        let sel = sels[selectedIndex]
        cell.config(sel.item[indexPath.section].children[indexPath.row])
        cell.itemSelected = sel.selectedRow == indexPath.section && sel.item[indexPath.section].selectedRow == indexPath.row
        
        if sel.type == .grade && hasSem && indexPath.section == 0 {
            cell.itemSelected = sel.item[indexPath.section].selectedRow == indexPath.row
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sel = sels[selectedIndex]
        return sel.item[section].children.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sel = sels[selectedIndex]
        return sel.item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 64) / 3, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sel = sels[selectedIndex]
        if sel.type == .grade && hasSem && indexPath.section == 0 {
            
        } else {
            sel.selectedRow = indexPath.section
        }
        
        sel.item[indexPath.section].selectedRow = indexPath.row
        if (sel.type == .subject) {
            sels[4].selectedRow = -1
            sels[4].item = []
        }
        update()
//        select()
    }
}
