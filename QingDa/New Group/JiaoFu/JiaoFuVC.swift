//
//  JiaoFuVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/9.
//

//首页
//https://lanhuapp.com/web/#/item/project/detailDetach?pid=8da277bb-b578-457d-8447-279fc9448973&image_id=41683b75-73df-44be-9684-e3fda22f20db&project_id=8da277bb-b578-457d-8447-279fc9448973&fromEditor=true&type=image

import UIKit

class JiaoFuVC: UIViewController {
    
    @IBOutlet weak var icon1:IconTitle!
    @IBOutlet weak var icon2:IconTitle!
    @IBOutlet weak var icon3:IconTitle!
    @IBOutlet weak var icon4:IconTitle!
    @IBOutlet weak var control:SegmentedControl!
    @IBOutlet weak var selector:Selector!
    @IBOutlet weak var bannerContainer: UIView!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vipLabel: UILabel!
    @IBOutlet weak var offset: NSLayoutConstraint!
    var banner: LLCycleScrollView!
    
    var vipOrder: VipOrder?
    var selectedIndex = 0
    var titleStrings = ["我的教辅", "推荐"]
    var items: [JiaoFuCellData] = []
    var recommend: [JiaoFuCellData] = []
    var sels = [PopSel(title: "年级", type: .grade),
                PopSel(title: "地区", type: .city)];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getBanner()
        getSubject()
        
        if gProvince == nil && gGrade == nil {
            let vc = FirstPopVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.tapAction = { [weak self] in
                guard let self = self else { return }
                self.updateGradeArea()
            }
            gTab?.present(vc, animated: false)
        }
    }
    
    func titles() -> [NSAttributedString] {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.black]
        var titles = [NSAttributedString]()
        for titleString in titleStrings {
            let title = NSAttributedString(string: titleString, attributes: attributes)
            titles.append(title)
        }
        return titles
    }
    
    func selectedTitles() -> [NSAttributedString] {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: HEX(kMainColor1)]
        var selectedTitles = [NSAttributedString]()
        for titleString in titleStrings {
            let selectedTitle = NSAttributedString(string: titleString, attributes: attributes)
            selectedTitles.append(selectedTitle)
        }
        return selectedTitles
    }
    
    func setControl() {
        control.setTitles(titles(), selectedTitles: selectedTitles())
        control.delegate = self
        control.selectionIndicatorStyle = .bottom
        control.layoutPolicy = .dynamic
        control.selectionIndicatorColor = HEX(kMainColor1)
        control.selectionIndicatorHeight = 4
        control.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        control.update()
        control.setSelected(at: 1, animated: false)
        control.setSelected(at: 0, animated: false)
        control.setSelected(at: selectedIndex, animated: false)
    }
    
    func setUI() {
        setBanner()
        setControl()
        collectionView.register(UINib(nibName: "JiaoFuCell", bundle: nil), forCellWithReuseIdentifier: "JiaoFuCell")
        collectionView.register(UINib(nibName: "AddCell", bundle: nil), forCellWithReuseIdentifier: "AddCell")
        
        icon1.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.FalseBook, from: self)
        }
        
        icon2.tapAction = {
            gTab?.selectedIndex = 1
//            Router.push(.Paper(type: 1), from: self)
        }
        
        icon3.tapAction = { [weak self] in
            guard let self = self else { return }
            Router.push(.studyRecord, from: self)
        }
        
        icon4.tapAction = { [weak self] in
            guard let self = self else { return }
            self.goVip()
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapGrade))
        selector.addGestureRecognizer(recognizer)
    }
    
    func setBanner() {
        let banner = LLCycleScrollView.llCycleScrollViewWithFrame(CGRect.init(x: 0, y: 0, width: kScreenW - 32, height: 134))
        
        banner.autoScrollTimeInterval = 3.0
        banner.imageViewContentMode = .scaleAspectFill
        
        banner.pageControlTintColor = .white
        banner.pageControlCurrentPageColor = HEX(kMainColor1)
        banner.pageControlPosition = .center
        banner.pageControlBottom = 15
        
        self.banner = banner
        self.bannerContainer.addSubview(banner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateGradeArea()
        getUserMessage()
        getMyCourse()
    }
    
    func updateGradeArea() {
        if let grade = gGrade {
            selector.title = grade
        }
        
        if let province = gProvince, let city = gCity {
            areaBtn.setTitle(province + city, for: .normal)
        }
    }
    
    func getUserMessage() {
        if (gToken == nil) {
            profile.image = UIImage(named: "组 53611");
            return
        }
        NetWork.request(.getUserMessage,
                        modelType: GetUserMessageResponse.self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.profile.load(model.user.headimage)
                if let vipOrder = model.vipOrder {
                    self.vipOrder = vipOrder
                    self.vipLabel.text = "\(vipOrder.sysName)，可免费订阅教辅数量\(vipOrder.sysAmount)/\(vipOrder.sysAmount)"
                }
            }
        }
    }
    
    @IBAction func goVip() {
        if let vipOrder = vipOrder {
            Router.push(.MyVip, from: self)
//            Router.push(.MyVipDetail(orderNumber: vipOrder.orderNumber), from: self)
        } else {
            Router.push(.Vip, from: self)
        }
    }
    
    @objc func tapGrade() {
        tapSelector(index: 0)
    }
    
    @IBAction func selectArea() {
        tapSelector(index: 1)
    }
    
    func tapSelector(index: Int) {
        let vc = PopSelVC()
        vc.sels = sels.clone()
        vc.selectedIndex = index
        vc.tapAction = {  [weak self] in
            guard let self = self else { return }
            self.sels = $0
            self.update()
        }
        vc.modalPresentationStyle = .overCurrentContext
        
        gTab?.present(vc, animated: false)
    }
    
    func update() {
        let grade = sels[0]
        if (grade.selectedRow >= 0) {
            let first = grade.item[grade.selectedRow]
            let grade = first.children[first.selectedRow].title
            selector.title = grade
            saveGrade(grade)
        }
        
        let city = sels[1]
        if (city.selectedRow >= 0 && city.item[city.selectedRow].selectedRow >= 0) {
            let first = city.item[city.selectedRow]
            let province = first.title
            let city = first.children[first.selectedRow].title
            if !province.isEmpty && !city.isEmpty {
                saveProvince(province)
                saveCity(city)
                areaBtn.setTitle(province + city, for: .normal)
            }
            
        }
    }
    
    func getBanner() {
        NetWork.request(.getBanner,
                        modelType: [GetBannerListResponse].self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.banner.imagePaths = model.map { $0.bannerUrl }
            }
        }
    }
    
    func getSubject() {
        NetWork.request(.getSys,
                        modelType: [GetSysResponse].self,
                        parameters: ["category": "8"]) { result, model, msg in
            if let model = model {
                self.titleStrings = self.titleStrings + model.map { $0.content }
                self.setControl()
            }
            self.control.isHidden = false
        }
    }
    
    func getRecommend() {
        if (!recommend.isEmpty) {
            items = recommend
            collectionView.reloadData()
        }
        let index = selectedIndex
        NetWork.request(.getRecommend,
                        modelType: [GetRecommendResponse].self,
                        parameters: [:]) { result, model, msg in
            if let model = model, index == self.selectedIndex {
                self.recommend = model.map{JiaoFuCellData(name: $0.courseName,
                                                          thumbnail: $0.thumbnail,
                                                          courseId: $0.courseId,
                                                          category: $0.category,
                                                          tags: [$0.suject, getGrade($0.grade, $0.semester )].filter {!$0.isEmpty})}
                self.items = self.recommend
                self.collectionView.reloadData()
            }
        }
    }
    
    func configControl() {
        if control.tag == 0 || selectedIndex == 0 {
            control.tag = 1
            segmentedControl(control, didSelectIndex: 1)
            control.setSelected(at: selectedIndex, animated: false)
        }
        self.offset.constant = -90
    }
    
    func getMyCourse() {
        if (!isLogin()) {
            configControl();
            return
        }
        NetWork.request(.getMyCourse,
                        modelType: GetMyCourseResponse.self,
                        parameters: ["pageNumber" : 1,
                                     "pageSize" : 100]) { result, model, msg in
            if let model = model {
                if (model.records.isEmpty) {
                    self.configControl()
                } else {
                    if 0 == self.selectedIndex {
                        self.items = model.records.map{JiaoFuCellData(name: $0.objectName,
                                                                   thumbnail: $0.thumbnail,
                                                                   courseId: $0.objectId,
                                                                   category: $0.category,
                                                                      tags: [$0.objectJson.suject, getGrade($0.objectJson.grade, $0.objectJson.semester )].filter {!$0.isEmpty})}
                        self.collectionView.reloadData()
                    }
                    self.offset.constant = 0
                }
            }
        }
    }
    
    func searchCourse(_ subject: String) {
        var dic = [
            "pageNumber" : 1,
            "pageSize" : 100,
            "suject": subject
        ] as [String : Any]
        
//        if let province = gProvince, let city = gCity {
//            dic["province"] = province
//            dic["city"] = city
//        }
        
        if let grade = gGrade {
            dic["grade"] = grade
        }
        
        let index = selectedIndex
        NetWork.request(.searchCourse,
                        modelType: GetSearchCourseResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model, index == self.selectedIndex {
                self.items = model.list.map{JiaoFuCellData(name: $0.name,
                                                           thumbnail: $0.thumbnail,
                                                           courseId: $0.courseId,
                                                           category: $0.category,
                                                           tags: [$0.suject, getGrade($0.grade, $0.semester)].filter {!$0.isEmpty})}
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func goSearch() {
        Router.push(.Search, from: self)
    }
    
    @IBAction func goProfile() {
        guard !isLogin() else {
            return
        }
        Router.present(.Login, from: self)
    }
}

extension JiaoFuVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row < items.count) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JiaoFuCell", for: indexPath) as! JiaoFuCell
            cell.config(items[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as! AddCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedIndex == 0 ? items.count + 1 : items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == items.count) {
            Router.push(.Search, from: self)
        } else {
            let data = items[indexPath.row]
            let courseId = data.courseId
            let vc = data.category == "1" ? RouterPage.Course2(courseId: courseId) : RouterPage.Course(courseId: courseId)
            Router.push(vc, from: self)
        }
    }
}

extension JiaoFuVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 40) / 3, height: (collectionView.bounds.width - 40) / 9 * 4 + 48)
    }
}

extension JiaoFuVC: SegmentedControlDelegate {
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelectIndex selectedIndex: Int) {
        self.items = []
        self.collectionView.reloadData()
        self.selectedIndex = selectedIndex
        if (selectedIndex == 0) {
            getMyCourse()
        } else if (selectedIndex == 1) {
            getRecommend()
        } else {
            searchCourse(titleStrings[selectedIndex])
        }
    }
}
