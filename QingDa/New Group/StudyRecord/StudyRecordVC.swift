//
//  StudyRecordVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/26.
//

import UIKit

class StudyRecordVC: UIViewController {
    
    var pageNumber = 1
    let pageSize = 10
    var items: [GetStudyRecordListItem] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        getStudyRecordList()
    }
    
    func setUI() {
        self.title = "学习记录"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func getStudyRecordList() {
        let dic = [
            "pageNumber" : pageNumber,
            "pageSize" : pageSize,
        ]
        NetWork.request(.getStudyRecordList,
                        modelType: GetStudyRecordListResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.items = model.records
                self.tableView.reloadData()
            }
        }
    }
}

extension StudyRecordVC: UITableViewDelegate, UITableViewDataSource {
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
