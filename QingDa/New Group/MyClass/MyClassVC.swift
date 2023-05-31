//
//  MyClassVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import UIKit

extension MyClassVC: CustomSegmentedControlDelegate {
    func change(to index:Int) {
        items = []
        tableView.reloadData()
        self.selectedIndex = index
        self.load()
    }
}

class MyClassVC: UIViewController {
    
    var type = 0
    var selectedIndex = 0
    var tabs = [""]
    var items: [GetMyCourseItem] = []
    @IBOutlet weak var control:CustomSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getSubject()
        
    }
    
    func setUI() {
        self.title = type == 0 ? "我的教辅" : "我的课堂"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        control.setButtonTitles(buttonTitles: [""])
        control.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func getSubject() {
        NetWork.request(.getSys,
                        modelType: [GetSysResponse].self,
                        parameters: ["category": "8"]) { result, model, msg in
            if let model = model {
                let subject = model.map {
                    $0.content
                }
                self.tabs = subject
                self.control.setButtonTitles(buttonTitles: subject)
                self.load()
            }
        }
    }
    
    func load() {
        if (self.type == 0) {
            self.searchCourse()
        } else {
            self.getMyCourse()
        }
    }
    
    func searchCourse() {
        let dic = [
            "pageNumber" : 1,
            "pageSize" : 100,
            "suject": tabs[selectedIndex]
        ] as [String : Any]
        let index = selectedIndex
        NetWork.request(.getMyCourse,
                        modelType: GetMyCourseResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model, index == self.selectedIndex {
                self.items = model.records
                self.tableView.reloadData()
            }
        }
    }
    
    func getMyCourse() {
        let dic = [
            "pageNumber" : 1,
            "pageSize" : 100,
            "suject": tabs[selectedIndex]
        ] as [String : Any]
        let index = selectedIndex
        NetWork.request(.getMyCoursePage,
                        modelType: GetMyCourseResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model, index == self.selectedIndex {
                self.items = model.records
                self.tableView.reloadData()
            }
        }
    }
}

extension MyClassVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.config(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseId = items[indexPath.row].objectId
        let vc = items[indexPath.row].category == "1" ? RouterPage.Course2(courseId: courseId) : RouterPage.Course(courseId: courseId)
        Router.push(vc, from: self)
    }
}
