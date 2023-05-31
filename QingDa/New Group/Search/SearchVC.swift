//
//  SearchVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/15.
//

//搜索教辅课程
//https://lanhuapp.com/web/#/item/project/detailDetach?pid=8da277bb-b578-457d-8447-279fc9448973&image_id=c18ea513-2c8e-4013-9ebe-4c35878d8530&tid=8406d474-88a1-48d5-8ebd-97ecaa111f9d&project_id=8da277bb-b578-457d-8447-279fc9448973&fromEditor=true&type=image

import UIKit

extension SearchVC: CustomSegmentedControlDelegate {
    func change(to index:Int) {
        self.index = index
        searchCourse()
    }
}

class SearchVC: UIViewController {
    
    var index = 0
    var pageNumber = 1
    let pageSize = 100
    var items: [GetSearchCourseItem] = []
    let searchBar = SearchBar()
    var sels = [PopSel(title: "地区", type: .city),
                PopSel(title: "年级", type: .grade),
                PopSel(title: "科目", type: .subject),
                PopSel(title: "年份", type: .year),
                PopSel(title: "版本", type: .edtion)]
    @IBOutlet weak var control: CustomSegmentedControl!
    @IBOutlet weak var selector: SelectorControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setUI()
        
        searchCourse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func setUI() {
        control.setButtonTitles(buttonTitles: ["教材课程", "教辅课程"])
        control.delegate = self
        selector.setButtonTitles(buttonTitles: ["区域", "年级", "科目", "年份", "版本"])
        selector.select = { [weak self] index in
            guard let self = self else { return }
            self.showPop(index)
        }
        
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        var rect = searchBar.frame;
        rect.size.width = kScreenW
        rect.size.height = 40
        searchBar.frame = rect
        searchBar.searchAction = { [weak self] (word) in
            guard let self = self else { return }
            self.searchCourse()
        }
        self.navigationItem.titleView = searchBar
    }
    
    func showPop(_ index: Int) {
        let vc = PopSelVC()
        vc.hasReset = true
        vc.hasSem = true
        vc.sels = sels.clone()
        vc.selectedIndex = index
        vc.tapAction = {  [weak self] in
            guard let self = self else { return }
            self.sels = $0
            self.searchCourse()
        }
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
    
    func searchCourse() {
        var dic = [
            "pageNumber" : pageNumber,
            "pageSize" : pageSize,
            "category" : index == 0 ? "1" : "2"
        ] as [String : Any]
        
        if (!searchBar.textField.text!.isEmpty) {
            dic["searchValue"] = searchBar.textField.text!
        }
        
        let city = sels[0]
        if (city.selectedRow >= 0 && city.item[city.selectedRow].selectedRow >= 0) {
            let first = city.item[city.selectedRow]
            dic["province"] = first.title
            dic["city"] = first.children[first.selectedRow].title
            selector.buttons[0].selected = true
            selector.buttons[0].title = first.children[first.selectedRow].title
        } else {
            selector.buttons[0].selected = false
            selector.buttons[0].title = "区域"
        }
        
        let grade = sels[1]
        if grade.item.count > 0 {
            let sem = grade.item[0]
            if sem.selectedRow >= 0 {
                dic["semester"] = "\(sem.selectedRow)"
            }
        }
        
        
        if (grade.selectedRow >= 0) {
            let first = grade.item[grade.selectedRow]
            dic["grade"] = first.children[first.selectedRow].title
            selector.buttons[1].selected = true
            selector.buttons[1].title = first.children[first.selectedRow].title
        } else {
            selector.buttons[1].selected = false
            selector.buttons[1].title = "年级"
        }
        
        let suject = sels[2]
        if (suject.selectedRow >= 0) {
            let first = suject.item[suject.selectedRow]
            dic["suject"] = first.children[first.selectedRow].title
            selector.buttons[2].selected = true
            selector.buttons[2].title = first.children[first.selectedRow].title
        } else {
            selector.buttons[2].selected = false
            selector.buttons[2].title = "科目"
        }
        
        let years = sels[3]
        if (years.selectedRow >= 0) {
            let first = years.item[years.selectedRow]
            dic["years"] = first.title
            selector.buttons[3].selected = true
            selector.buttons[3].title = first.title
        } else {
            selector.buttons[3].selected = false
            selector.buttons[3].title = "年份"
        }
        
        let edtion = sels[4]
        if (edtion.selectedRow >= 0) {
            let first = edtion.item[edtion.selectedRow]
            dic["edition"] = first.title
            selector.buttons[4].selected = true
            selector.buttons[4].title = first.title
        } else {
            selector.buttons[4].selected = false
            selector.buttons[4].title = "版本"
        }
        
        NetWork.request(.searchCourse,
                        modelType: GetSearchCourseResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.items = model.list
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.config(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseId = items[indexPath.row].courseId
        let vc = items[indexPath.row].category == "1" ? RouterPage.Course2(courseId: courseId) : RouterPage.Course(courseId: courseId)
        Router.push(vc, from: self)
    }
    
}
