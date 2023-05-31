//
//  PaperVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/26.
//

import UIKit
import PhotoSlider

extension PaperVC: CustomSegmentedControlDelegate {
    func change(to index:Int) {
        items = []
        tableView.reloadData()
        self.selectedIndex = index
        self.pageNumber = 1
        getPaperList()
    }
}

class PaperVC: UIViewController {
    
    var type = 0
    var pageNumber = 1
    let pageSize = 20
    var tabs = [""]
    var selectedIndex = 0
    @IBOutlet weak var control:CustomSegmentedControl!
    @IBOutlet weak var selector: SelectorControl!
    @IBOutlet weak var tableView: UITableView!
    
    var items: [GetPaperListItem] = []
    var sels = [PopSel(title: "区域", type: .city),
                PopSel(title: "年级", type: .grade),
                PopSel(title: "年份", type: .year),
                PopSel(title: "考试类型", type: .exam)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getSubject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "试卷库"
        self.navigationController?.setNavigationBarHidden(type == 0 ? true : false, animated: false)
    }
    
    func setUI() {
        control.setButtonTitles(buttonTitles: tabs)
        control.delegate = self;
        
        selector.setButtonTitles(buttonTitles: ["区域", "年级", "年份", "考试类型"])
        selector.select = { [weak self] index in
            guard let self = self else { return }
            self.showPop(index)
        }
        
        tableView.register(UINib(nibName: "PaperCell", bundle: nil), forCellReuseIdentifier: "PaperCell")
        
        
        // 将 footer 的类型设置为 MJRefreshAutoNormalFooter
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else {
                return
            }
            self.refresh()
        })
        
        // 将箭头转换方向（上拉状态下显示向上箭头）
        if let footer = tableView.mj_footer as? MJRefreshBackNormalFooter {
            footer.setTitle("上拉加载更多", for: .idle)
            footer.setTitle("释放加载更多", for: .pulling)
            footer.setTitle("加载中...", for: .refreshing)
            footer.setTitle("到底啦~", for: .noMoreData)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: PaySuccessNotification, object: nil)
    }
    
    @objc func refresh() {
        getPaperList()
    }
    
    func showPop(_ index: Int) {
        let vc = PopSelVC()
        vc.hasReset = true
        vc.hasSem = true
        vc.sels = sels.clone()
        vc.type = 1
        vc.selectedIndex = index
        vc.tapAction = {  [weak self] in
            guard let self = self else { return }
            self.sels = $0
            self.getPaperList()
        }
        vc.modalPresentationStyle = .overCurrentContext
        gTab?.present(vc, animated: false)
    }
    
    func getPaperList() {
        var dic = [
            "pageNumber" : pageNumber,
            "pageSize" : pageSize,
            "suject" : tabs[selectedIndex]
        ] as [String : Any]
        
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
        
        let years = sels[2]
        if (years.selectedRow >= 0) {
            let first = years.item[years.selectedRow]
            dic["years"] = first.title
            selector.buttons[2].selected = true
            selector.buttons[2].title = first.title
        } else {
            selector.buttons[2].selected = false
            selector.buttons[2].title = "年份"
        }
        
        let examType = sels[3]
        if (examType.selectedRow >= 0) {
            let map = [
                "月考" : 1,
                "期中" : 2,
                "期末" : 3,
                "中考真题" : 4,
                "中考模拟" : 5,
            ]
            let first = examType.item[examType.selectedRow]
            dic["examType"] = map[first.title]
            selector.buttons[3].selected = true
            selector.buttons[3].title = first.title
        } else {
            selector.buttons[3].selected = false
            selector.buttons[3].title = "考试类型"
        }
        
        if type == 0 {
            NetWork.request(.getPaperList,
                            modelType: GetPaperListResponse.self,
                            parameters: dic) { result, model, msg in
                if let model = model {
                    self.items = self.items + model.testPageList.list
                    self.tableView.reloadData()
                    if model.testPageList.list.count > 0 {
                        self.tableView.mj_footer?.endRefreshing()
                        self.pageNumber += 1
                    } else {
                        self.tableView.mj_footer?.state = .noMoreData
                    }
                }
            }
        } else {
            NetWork.request(.getMyTestPaper,
                            modelType: GetPaperPageList.self,
                            parameters: dic) { result, model, msg in
                if let model = model {
                    self.items = model.list
                    self.tableView.reloadData()
//                    if self.items.count > 0 {
//                        self.tableView.mj_footer?.endRefreshing()
//                        self.pageNumber += 1
//                    } else {
//                        self.tableView.mj_footer?.state = .noMoreData
//                    }
                }
            }
        }
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
                self.getPaperList()
            }
        }
    }
}

extension PaperVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaperCell", for: indexPath) as! PaperCell
        cell.config(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        if item.ifSubscribe == "0", Double(item.price) ?? 0 > 0  {
            let vc = PaperPopVC()
            vc.name = item.name
            vc.price = item.price
            vc.modalPresentationStyle = .overFullScreen
            vc.tapAction = { [weak self] in
                guard let self = self else { return }
                self.createCourse(id: item.id, price: item.price)
            }
            present(vc, animated: false)
            return
        }
        
        if item.paperType == "1" {
            Router.push(.Web(type: .shijuan(id: item.id, title: item.name, pdf: "")), from: self)
        } else {
            Router.push(.Web(type: .shijuan(id: item.id, title: item.name, pdf: item.fileUrl)), from: self)
        }
    }
    
    func createCourse(id: String, price: String) {
        Router.push(.Pay(type: PayType.course(price: price, objectId: id, couponId: nil, category: "2")), from: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
}
