//
//  Course2VC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/27.
//

import UIKit
import CollapsibleTableSectionViewController
import Toaster
import AVKit

extension Course2VC: CustomSegmentedControlDelegate {
    func change(to index:Int) {
        self.tabIndex = index
        tableView.reloadData()
    }
}

class Course2VC: UIViewController {
    var section:GetCourseDetilsOneList?
    var row:GetCourseDetilsItem?
    var progress: Int = -1
    var observer: Any?
    var courseId: String = ""
    var selectedIndex: Int = 0
    var tabIndex: Int = 0
    var images: [String] = []
    var imageIndex = 0
    var start: TimeInterval = Date().timeIntervalSince1970
    var price = ""
    
    var detilsOne: GetCourseDetilsOneDetils? = nil {
        didSet {
            if let data = detilsOne {
                banner.load(data.thumbnail)
                name.text = data.name
                lesson.text = ""
                subscribeCount.text = data.salesFalse + "人在学习"
                tagListView.removeAllTags()
                tagListView.addTags([data.suject, getGrade(data.grade, data.semester), data.edition, data.years].filterEmpty())
                configInfo()
            }
        }
    }
    var list: [GetCourseDetilsOneList] = []
    
    var detilsTwo: GetCourseDetilsTwoResponse? = nil {
        didSet {
            if let data = detilsTwo {
                if let coupon = data.coupon {
                    self.coupon.text = String(coupon.discountAmount) + "元优惠券"
                } else {
                    couponView?.isHidden = true
                }
                configInfo()
            }
        }
    }
    var rateBtn:UIButton?
    let rates = ["1", "1.5", "2", "0.5"]
    var rateIndex = 0
    var video:AVPlayerViewController? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var subscribeCount: UILabel!
    @IBOutlet weak var lesson: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var tryBtn: UIButton!
    @IBOutlet weak var tagListView:TagListView!
    @IBOutlet weak var control:CustomSegmentedControl!
    @IBOutlet weak var couponView:UIView?
    @IBOutlet weak var guestView:UIStackView!
    @IBOutlet weak var full:UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var word:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = UserDefaults.standard.integer(forKey: courseId + "section")
        setUI()
        getCourseTrialLearn(nil, nil)
        courseDetilsOne()
        courseDetilsTwo()
        startLoading(transparent: false)
    }
    
    func configInfo() {
        if let detilsOne = detilsOne, let detilsTwo = detilsTwo {
            var orderString = ""
            var color = HEX("#FE8328")
            
            if detilsTwo.ifBuy > 0 {
                orderBtn.isHidden = true
                heightConstraint.constant = 0
                guestView.removeAll()
            } else if detilsOne.price == 0 {
                orderString = "免费订阅"
                color = HEX("#24D06D")
            } else if (detilsTwo.ifVipOrder == 1) {
                orderString = "免费订阅" + detilsTwo.vipOrderCount
                color = HEX("#24D06D")
            } else if let coupon = detilsTwo.coupon, detilsOne.price - coupon.discountAmount > 0 {
                orderString = "劵后购买（¥" + String(format:"%.2f）", detilsOne.price - coupon.discountAmount) + "\n¥\( detilsOne.price)"
                price = String(format:"%.2f）", detilsOne.price - coupon.discountAmount)
            } else {
                orderString = "立即订阅（¥" + String(format:"%.2f", detilsOne.price) + "）"
                price = String(format:"%.2f", detilsOne.price)
            }
            orderBtn.backgroundColor = color
            orderBtn.titleLabel?.textAlignment = .center
            orderBtn.titleLabel?.numberOfLines = 0
            orderBtn.setTitle(orderString, for: .normal)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.stopLoading()
                if let header = self.tableView.tableHeaderView {
                    let maxY = self.control.frame.maxY
                    var rect = header.frame
                    rect.size.height = maxY
                    header.frame = rect
                    self.tableView.tableHeaderView = header
                }
            }
            
            word.title = detilsTwo.isBookAdded == 0 ? "加入书架" : "移除书架"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        start = Date().timeIntervalSince1970
        video?.player?.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let time = String(Int(Date().timeIntervalSince1970 - start))
        let dic = [
            "objectId" : courseId,
            "time" : time,
            "category" : "1"
        ]
        NetWork.request(.updateStudyTimeCount,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                
            }
        }
        video?.player?.pause()
        submitStudyRecordDirectory()
    }
    
    func setUI() {
        let item1 = UIBarButtonItem(image: IMAGE("组 61415-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(goCart))
        
        word = UIBarButtonItem.init(title: "加入书架", style: .plain, target: self, action: #selector(addBook))
        word.tintColor = HEX(kMainColor2)
        
        let item2 = UIBarButtonItem(image: IMAGE("组 61414-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addBook))
        
        navigationItem.rightBarButtonItems = [item1, word, item2]
        
        tableView.register(UINib(nibName: "CourseHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "CourseHeader")
        tableView.register(UINib(nibName: "CourseCell", bundle: nil), forCellReuseIdentifier: "CourseCell")
        tableView.register(UINib(nibName: "WebCell", bundle: nil), forCellReuseIdentifier: "WebCell")
        
        self.control.setButtonTitles(buttonTitles: ["课程目录", "课程介绍"])
        control.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: PaySuccessNotification, object: nil)
        
        collectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
    }
    
    @objc func refresh() {
        startLoading(transparent: false)
        courseDetilsTwo()
    }
    
    @objc
    func addBook() {
        let message = self.detilsTwo?.isBookAdded ?? 0 == 0 ? "把课程添加到书架，方便下次查看" : "把课程从书架移除?"
        let title = self.detilsTwo?.isBookAdded ?? 0 == 0 ? "存入" : "移除"
        let menu = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let unReceive = UIAlertAction(title: "忽略", style: .default) { _ in
            
        }
        unReceive.setValue(UIColor.black, forKey: "_titleTextColor")
        let receive = UIAlertAction(title: title, style: .default) { [weak self] _ in
            guard let self = self else { return }
            if self.detilsTwo?.isBookAdded ?? 0 == 0 {
                self.addBookcase()
            } else {
                self.removeBookcase()
            }
            
        }
        receive.setValue(HEX(kMainColor1), forKey: "_titleTextColor")
        
        menu.addAction(unReceive)
        menu.addAction(receive)
        self.present(menu, animated: true, completion: nil)
    }
    
    func removeBookcase() {
        let dic = [
            "courseId" : courseId,
        ]
        NetWork.request(.deleteBookcase,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                self.word.title = "加入书架"
                self.detilsTwo?.isBookAdded = 0
                Toast(text: "操作成功", duration: 0.5).show()
            }
        }
    }
    
    func addBookcase() {
        let dic = [
            "courseId" : courseId,
        ]
        NetWork.request(.addBookcase,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                self.word.title = "移除书架"
                self.detilsTwo?.isBookAdded = 1
                Toast(text: "操作成功", duration: 0.5).show()
            }
        }
    }
    
    @objc
    func goCart() {
        
    }
    
    func courseDetilsOne() {
        let dic = [
            "courseId" : courseId,
        ]
        NetWork.request(.courseDetilsOne,
                        modelType: GetCourseDetilsOneResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.detilsOne = model.detils
                self.list = model.list
                self.tableView.reloadData()
            }
        }
    }
    
    func courseDetilsTwo() {
        let dic = [
            "courseId" : courseId,
        ]
        NetWork.request(.courseDetilsTwo,
                        modelType: GetCourseDetilsTwoResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.detilsTwo = model
            }
        }
    }
    
    @IBAction func order() {
        var couponId: String? = nil
        
        if let data = detilsTwo, let detilsOne = detilsOne {
            if let coupon = data.coupon, detilsOne.price - coupon.discountAmount > 0 {
                couponId = coupon.couponId
            }
        }
        
        Router.push(.Pay(type: PayType.course(price: price, objectId: courseId, couponId: couponId, category: "1")), from: self)
    }
    
    @IBAction func goFull() {
        Router.present(.Photo(index: imageIndex, images: images), from: self, animated: false)
    }
}

extension Course2VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tabIndex == 1 {
            return 0.1
        }
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tabIndex == 1 {
            return nil
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CourseHeader") as! CourseHeader
        
        let sum = list[section].list.reduce(0) { partialResult, item in
            partialResult + (item.ifStudy == "0" ? 0 : 1)
        }
        header.name.text = list[section].name
        header.read.text = list[section].list.count == 0 ? "未更新" : "\(sum)/" + String(list[section].list.count)
        header.selected = section == selectedIndex
        header.tapAction = { [weak self] in
            guard let self = self else { return }
            if section == self.selectedIndex {
                self.selectedIndex = -1
            } else {
                self.selectedIndex = section
                UserDefaults.standard.set(section, forKey: self.courseId + "section")
            }
            self.tableView.reloadData()
        }
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tabIndex == 1 {
            return 1
        }
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabIndex == 1 {
            return 1
        }
        return section == selectedIndex ? list[section].list.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tabIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WebCell", for: indexPath) as! WebCell
            cell.config(content: detilsOne?.content ?? "")
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCell
        let children = list[indexPath.section].list
        cell.config(String(indexPath.row + 1) + "/" + String(children.count), children[indexPath.row], detilsTwo?.ifBuy ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tabIndex == 1 {
            return 530
        }
        return 48
    }
    
    func submitStudyRecordDirectory(completion: (() -> Void)? = nil) {
        if let section = section, let row = row, progress >= 0 {
            let progress = String(progress)
            let dic = [
                "courseId" : courseId,
                "pointId" : row.id,
                "parentId" : section.parentId,
                "studyBili" : progress,
            ]
            
            row.studyBili = progress
            row.ifStudy = "1"
            self.tableView.reloadData()
            
            NetWork.request(.submitStudyRecordDirectory,
                            modelType: NoneResponseData.self,
                            parameters: dic) { result, model, msg in
                if let _ = model {
                    completion?()
                }
            }
        } else {
            completion?()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tabIndex == 1 {
            return
        }
        let children = list[indexPath.section].list
        let item = children[indexPath.row]
        
        if item.videoUrl.isEmpty {
            return
        }
        
        if (detilsTwo?.ifBuy ?? 0 > 0) {
            submitStudyRecordDirectory()
            study(list[indexPath.section], item)
        } else {
            submitStudyRecordDirectory { [weak self] in
                guard let self = self else { return }
                self.getCourseTrialLearn(self.list[indexPath.section], item)
            }
        }
        
    }
    
    func getCourseTrialLearn(_ selectedSection: GetCourseDetilsOneList?, _ item: GetCourseDetilsItem?) {
        let dic = [
            "courseId" : courseId
        ]
        NetWork.request(.getCourseTrialLearn,
                        modelType: GetCourseTrialLearnResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.tryBtn.setTitle("已试听\(model.userTryCount)/\(model.courseTryCount)节，购买后解锁全部课程", for: .normal)
                if let selectedSection = selectedSection, let item = item {
                    if Int(model.userTryCount) ?? 0 >= Int(model.courseTryCount) ?? 0 {
                        self.stop()
                    } else {
                        self.study(selectedSection, item)
                    }
                }
            }
        }
    }
    
    func stop() {
        let menu = UIAlertController(title: nil, message: "免费试学次数已用完，订阅后可学习全部课程！", preferredStyle: .alert)
        let receive = UIAlertAction(title: "确认", style: .default) { [weak self] _ in
            guard let _ = self else { return }
            
        }
        receive.setValue(HEX(kMainColor1), forKey: "_titleTextColor")
        menu.addAction(receive)
        self.present(menu, animated: true, completion: nil)
    }
    
    func study(_ selectedSection: GetCourseDetilsOneList, _ item: GetCourseDetilsItem) {
        images = []
        imageIndex = 0
        if let observer = self.observer {
            self.video?.player?.removeTimeObserver(observer)
        }
        video?.removeFromParent()
        video?.view.removeFromSuperview()
        video?.player?.pause()
        
        progress = -1
        
        banner.load("")
        full.isHidden = true
        section = nil
        row = nil
        video = nil
        
        section = selectedSection
        row = item
        if let url = URL(string: item.videoUrl),
           item.category == "1"
        {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            playerViewController.view.frame = banner.frame
            self.addChild(playerViewController)
            video = playerViewController
            banner.superview?.addSubview(playerViewController.view)
            

            var first = true
            observer = player.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: CMTimeScale(NSEC_PER_SEC)), queue: nil, using: {(cmtime) in
                if first {
                    let timeStart = CMTimeGetSeconds(player.currentItem!.duration) * (Double(item.studyBili) ?? 0) / 100
                    let time = CMTimeMakeWithSeconds(Float64(timeStart), preferredTimescale: 1);
                    player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    first = false
                } else {
                    let time = CMTimeGetSeconds(player.currentItem!.duration)
                    if self.video != nil && time < 60 * 60 * 60 {
                        self.progress = Int(floor(cmtime.seconds / time * 100))
                    }
                }
            })
//            player.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.setRate()
            }
            
        } else if item.category == "2" && !item.videoUrl.isEmpty {
            images = item.videoUrl.components(separatedBy: ",")
            if !images.isEmpty {
                banner.load(images[imageIndex])
                progress = 100 * (imageIndex + 1) / images.count
            }
            full.isHidden = false
        }
        collectionView.reloadData()
        addStudyRecord(pointId: item.id)
    }
    
    func setRate() {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("倍速:1x", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        let last = self.video?.view?.subviews.first
        btn.frame = CGRect(x: (last?.frame.width ?? 0) - 55, y: 0, width: 55, height: 20)
        rateBtn = btn
        last?.addSubview(btn)
    }
    
    @objc
    func tap(){
        rateIndex += 1
        rateIndex = rateIndex % rates.count
        rateBtn?.setTitle("倍速:\(rates[rateIndex])x", for: .normal)
        video?.player?.rate = Float(rates[rateIndex]) ?? 1
    }
    
    func addStudyRecord(pointId: String) {
        NetWork.request(.addStudyRecord,
                        modelType: NoneResponseData.self,
                        parameters: ["courseId":courseId, "pointId":pointId]) { result, model, msg in
            if let _ = model {
            }
        }
    }
}

extension Course2VC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.config(images[indexPath.row], radius: 2, selected: indexPath.row == imageIndex)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 38, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageIndex = indexPath.row
        banner.load(images[indexPath.row])
        progress = 100 * (imageIndex + 1) / images.count
        collectionView.reloadData()
    }
}
