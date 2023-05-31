//
//  CourseVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/16.
//

//课辅课程
//https://lanhuapp.com/web/#/item/project/detailDetach?pid=8da277bb-b578-457d-8447-279fc9448973&image_id=efbd2e47-82b1-4672-a3f0-15339e0840ed&tid=8406d474-88a1-48d5-8ebd-97ecaa111f9d&project_id=8da277bb-b578-457d-8447-279fc9448973&fromEditor=true&type=image

import UIKit
import Toaster
import AVKit
import PhotoSlider

extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = HEX(kMainColor3).cgColor
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize(width: 0, height: 3)
  }
}

class CourseVC: UIViewController {
    
    @IBOutlet weak var addBtn:UIButton!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var pop:UIView!
    @IBOutlet weak var selector:Selector!
    @IBOutlet weak var selector2:Selector!
    @IBOutlet weak var thumbnail:UIImageView!
    @IBOutlet weak var subscribeCount:UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tagScrollView:TagScrollView!
    @IBOutlet weak var tagScrollView2:TagScrollView!
    @IBOutlet weak var tagListView:TagListView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var shadowView:UIView!
    @IBOutlet weak var videoCon:UIView!
    @IBOutlet weak var answerCon:UIView!
    @IBOutlet weak var wordCon:UIView!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var couponView:UIView!
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var orderCon: UIView!
    @IBOutlet weak var guestView:UIStackView!
    @IBOutlet weak var correctAnswer:UILabel!
    @IBOutlet weak var parse:UILabel!
    @IBOutlet weak var borderView: UIView!
    var word:UIBarButtonItem!
    @IBOutlet weak var tryBtn: UIButton?
    
    var rateBtn:UIButton?
    var price = ""
    var progress: Int = -1
    var item : GetCourseDetilsItem? = nil
    
    let rates = ["1", "1.5", "2", "0.5"]
    var rateIndex = 0
    var bookIndex = 0
    var video:AVPlayerViewController? = nil
    var observer: Any?
    
    var items: [String] = []
    var currentQ:GetQuestionAnalyseResponse? = nil
    
    var detilsOne: GetCourseDetilsOneDetils? = nil {
        didSet {
            if let data = detilsOne {
                name.text = data.name
                thumbnail.load(data.thumbnail)
                subscribeCount.text = data.salesFalse + "人在学习"
                
                tagListView.removeAllTags()
                tagListView.addTags([data.suject, getGrade(data.grade, data.semester), data.edition, data.years].filterEmpty())
                
                configInfo()
            }
        }
    }
    
    var detilsTwo: GetCourseDetilsTwoResponse? = nil {
        didSet {
            if let data = detilsTwo {
                if let coupon = data.coupon {
                    self.coupon.text = String(format:"%.0f", coupon.discountAmount) + "元优惠券"
                } else {
                    couponView.isHidden = true
                }
                configInfo()
            }
        }
    }
    
    func configInfo() {
        if let detilsOne = detilsOne, let detilsTwo = detilsTwo {
            var orderString = ""
            var color = orderBtn.backgroundColor
            if detilsTwo.ifBuy > 0 {
                orderBtn.isHidden = true
                orderCon.isHidden = true
                guestView.removeAll()
            } else if detilsOne.price == 0 {
//                orderString = "免费订阅"
//                color = HEX("#24D06D")
                orderBtn.isHidden = true
            } else if (detilsTwo.ifVipOrder == 1) {
                orderString = "免费订阅" + detilsTwo.vipOrderCount
                color = HEX("#24D06D")
            } else if let coupon = detilsTwo.coupon, detilsOne.price - coupon.discountAmount > 0 {
                orderString = "劵后购买（¥" + String(format:"%.2f）", detilsOne.price - coupon.discountAmount) + "¥\( detilsOne.price)"
                price = String(format:"%.2f）", detilsOne.price - coupon.discountAmount)
            } else {
                orderString = "立即订阅（¥" + String(format:"%.2f", detilsOne.price) + "）"
                price = String(format:"%.2f", detilsOne.price)
            }
            orderBtn.backgroundColor = color
            orderBtn.titleLabel?.textAlignment = .center
            orderBtn.titleLabel?.numberOfLines = 0
            orderBtn.setTitle(orderString, for: .normal)
            stopLoading()
            word.title = detilsTwo.isBookAdded == 0 ? "加入书架" : "移除书架"
        }
    }
    
    var courseId: String = ""
    var list: [GetCourseDetilsOneList] = [] {
        didSet {
            sels = [PopSel(title: "",
                           type: .selection,
                           item: list.map {
                PopSelItem(title: $0.name, children: $0.children.map {
                    PopSelItem(title: $0.name, children:[])
                })
            })]
        }
    }
    var firstIndex: Int = 0
    var secondIndex: Int = 0
    var thirdIndex: Int = 0
    var sels: [PopSel] = [];
    var start: TimeInterval = Date().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstIndex = UserDefaults.standard.integer(forKey: courseId + "firstIndex")
        self.secondIndex = UserDefaults.standard.integer(forKey: courseId + "secondIndex")
        self.thirdIndex = UserDefaults.standard.integer(forKey: courseId + "thirdIndex")
        
        setUI()
        courseDetilsOne()
        courseDetilsTwo()
        getCourseAnalysis()
        getCourseTrialLearn(nil)
        startLoading(transparent: false)
        bookIndex = UserDefaults.standard.integer(forKey: courseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        start = Date().timeIntervalSince1970
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
            "category" : "2"
        ]
        NetWork.request(.updateStudyTimeCount,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                
            }
        }
        
        if let item = item {
            submitStudyRecordDirectory(item)
        }
        
        video?.player?.pause()
    }
    

    func setUI() {
        tagListView.tagBackgroundColor = .white
        tagListView.textColor = HEX(kMainColor1)
        
        collectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        
        
        shadowView.clipsToBounds = true
        shadowView.layer.cornerRadius = 10
        shadowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        shadowView.dropShadow()
        
        let item1 = UIBarButtonItem(image: IMAGE("组 61415").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addBook))
        
        word = UIBarButtonItem.init(title: "加入书架", style: .plain, target: self, action: #selector(addBook))
        word.tintColor = .white
        
        let item2 = UIBarButtonItem(image: IMAGE("组 61414").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(goCart))
        
        navigationItem.rightBarButtonItems = [item1, word, item2]
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: PaySuccessNotification, object: nil)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapSelector))
        selector.addGestureRecognizer(recognizer)
        
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(tapSelector))
        selector2.addGestureRecognizer(recognizer2)
        
        selector.selected = true
        selector2.selected = true
        
        videoView.layer.borderWidth = 2
        videoView.layer.borderColor = HEX(kMainColor1).cgColor
    }
    
    @objc func refresh() {
        startLoading()
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
                if (!model.list.isEmpty) {
                    let firstItem = model.list[self.firstIndex]
                    self.selector.title = firstItem.name
                    self.selector2.title = firstItem.name
                    
                    if !model.list[self.firstIndex].children.isEmpty {
                        self.configMenu(first: true)
                    }
                }
            }
        }
    }
    
    @IBAction func closePop() {
        video?.player?.pause()
        pop.isHidden = true
    }
    func configMenu(first:Bool = false) {
        if (first) {
            if (UserDefaults.standard.object(forKey: courseId + "thirdIndex") != nil) {
                self.pop.isHidden = false
            }
        } else {
            thirdIndex = 0
        }
        let firstItem = list[self.firstIndex]
        let secondItem = list[self.firstIndex].children[self.secondIndex]
        self.selector.title = firstItem.name + "/" + secondItem.name
        self.selector2.title = firstItem.name + "/" + secondItem.name
        
        tagScrollView.items = secondItem.list.map { $0.name }
        tagScrollView2.items = secondItem.list.map { $0.name }
        tagScrollView.index = thirdIndex;
        tagScrollView2.index = thirdIndex;
        
        tagScrollView.tapAction = { [weak self] index in
            guard let self = self else { return }
            if let item = self.item {
                self.submitStudyRecordDirectory(item)
            }
            
            self.tagScrollView2.index = index
            self.thirdIndex = index
            self.configContent()
            
            self.progress = -1
            self.pop.isHidden = false
            UserDefaults.standard.set(index, forKey: self.courseId + "thirdIndex")
        }
        tagScrollView.scrollViewDidScroll = { [weak self] offset in
            self?.tagScrollView2.collectionView.contentOffset.x = offset
        }
        tagScrollView2.tapAction = { [weak self] index in
            guard let self = self else { return }
            if let item = self.item {
                self.submitStudyRecordDirectory(item)
            }
            
            self.tagScrollView.index = index
            self.thirdIndex = index
            self.configContent()
            
            self.progress = -1
            UserDefaults.standard.set(index, forKey: self.courseId + "thirdIndex")
        }
        tagScrollView2.scrollViewDidScroll = { [weak self] offset in
            self?.tagScrollView.collectionView.contentOffset.x = offset
        }
        configContent()
    }
    
    @IBAction func next() {
        let firstItem = list[self.firstIndex]
        if firstItem.children.isEmpty { return }
        
        let secondItem = firstItem.children[self.secondIndex]
        if secondItem.list.isEmpty { return }
        
        if (thirdIndex < secondItem.list.count - 1) {
            thirdIndex = thirdIndex + 1
            tagScrollView.index = thirdIndex
            tagScrollView2.index = thirdIndex
            self.configContent()
        }
    }
    
    func configContent() {
        if let observer = self.observer {
            self.video?.player?.removeTimeObserver(observer)
            self.observer = nil
        }
        video?.removeFromParent()
        video?.view.removeFromSuperview()
        correctAnswer.attributedText = "".htmlToAttributedString
        parse.attributedText = " ".htmlToAttributedString
        
        let frame = borderView.convert(borderView.bounds, to: view)
        heightConstraint.constant = frame.origin.y
        
        let firstItem = list[self.firstIndex]
        if firstItem.children.isEmpty { return }
        
        let secondItem = firstItem.children[self.secondIndex]
        if secondItem.list.isEmpty { return }
        
        let item = secondItem.list[thirdIndex]
        self.item = item
        
        if (detilsTwo?.ifBuy ?? 0 > 0 || Double(item.studyBili) ?? 0 > 0 || detilsOne?.price == 0) {
            study(item)
        } else {
            getCourseTrialLearn(item)
        }
        
    }
    
    func study(_ item: GetCourseDetilsItem) {
        addStudyRecord(pointId: item.id)
        NetWork.request(.getQuestionAnalyse,
                        modelType: GetQuestionAnalyseResponse.self,
                        parameters: ["questionId":item.questionId]) { result, model, msg in
            if let model = model {
                self.currentQ = model
                self.configQuestion(item.aliyunVideoId, item)
            }
        }
    }
    
    func configQuestion(_ videoId: String, _ item: GetCourseDetilsItem) {
        guard let currentQ = currentQ else { return }
        let question = currentQ.question
        if !videoId.isEmpty {
            videoCon.isHidden = false
            videoCon.setNeedsLayout()
//            let player = AVPlayer(url: url)
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//            playerViewController.view.frame = videoView.bounds
//
//            self.addChild(playerViewController)
//            video = playerViewController
//            videoView.insertSubview(playerViewController.view, at: 0)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.setRate()
//            }
//
            getPlayInfoWithOptions(videoId, item)
        } else {
            videoCon.isHidden = true
        }
        addBtn.setTitle(currentQ.ifErrorBook == 0 ? "加入错题本" : "移除错题本", for: .normal)
        correctAnswer.attributedText = question.correctAnswer.htmlToAttributedString
        answerCon.isHidden = question.correctAnswer.isEmpty
        parse.attributedText = question.parse.htmlToAttributedString
        wordCon.isHidden = question.parse.isEmpty
    }
    
    func getPlayInfoWithOptions(_ videoId: String, _ item: GetCourseDetilsItem) {
        NetWork.request(.getPlayInfoWithOptions,
                        modelType: GetPlayInfoWithOptionsResponse.self,
                        parameters: ["videoId":videoId]) { result, model, msg in
            if let model = model {
                if !model.playInfoList.playInfo.isEmpty {
                    let info = model.playInfoList.playInfo[0]
                    if let url = URL.init(string: info.playURL) {
                        self.showVideo(url, item)
                    }
                }
            }
        }
    }
    
    func showVideo(_ url: URL, _ item: GetCourseDetilsItem) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = videoView.bounds
        
        self.addChild(playerViewController)
        video = playerViewController
        videoView.insertSubview(playerViewController.view, at: 0)
        
        var first = true
        observer = player.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: CMTimeScale(NSEC_PER_SEC)), queue: nil, using: {(cmtime) in
            if first {
                if self.video != nil {
                    self.submitStudyRecordDirectory(item, true)
                }
                let timeStart = CMTimeGetSeconds(player.currentItem!.duration) * (Double(item.studyBili) ?? 0) / 100
                
                if timeStart > 0 {
                    let time = CMTimeMakeWithSeconds(Float64(timeStart), preferredTimescale: 1);
                    player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                    first = false
                }
            } else {
                let time = CMTimeGetSeconds(player.currentItem!.duration)
                if self.video != nil && time < 60 * 60 * 60 {
                    self.progress = Int(floor(cmtime.seconds / time * 100))
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setRate()
        }
    }
    
    func setRate() {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("倍速:1x", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        let last = self.video?.view?.subviews.first
        btn.frame = CGRect(x: 20, y: 0, width: 55, height: 20)
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
    
    @objc func tapSelector() {
        let vc = PopSelVC()
        vc.sels = sels.clone()
        vc.tapAction = {  [weak self] in
            guard let self = self else { return }
            self.sels = $0
            self.update()
        }
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
    
    func update() {
        let sel = sels[0]
        if (sel.selectedRow >= 0 && sel.item[sel.selectedRow].selectedRow >= 0) {
            firstIndex = sel.selectedRow
            secondIndex = sel.item[sel.selectedRow].selectedRow
            UserDefaults.standard.set(firstIndex, forKey: self.courseId + "firstIndex")
            UserDefaults.standard.set(secondIndex, forKey: self.courseId + "secondIndex")
            
            configMenu()
        }
    }
    
    func addStudyRecord(pointId: String) {
        NetWork.request(.addStudyRecord,
                        modelType: NoneResponseData.self,
                        parameters: ["courseId":courseId, "pointId":pointId]) { result, model, msg in
            if let _ = model {
            }
        }
    }
    
    func submitStudyRecordDirectory(_ item: GetCourseDetilsItem, _ force: Bool = false) {
        if progress >= 0 || force {
            let progress = progress < 1 ? "1" : String(progress)
            let dic = [
                "courseId" : courseId,
                "pointId" : item.id,
                "parentId" : item.directoryId,
                "studyBili" : progress,
            ]
            item.studyBili = progress

            NetWork.request(.submitStudyRecordDirectory,
                            modelType: NoneResponseData.self,
                            parameters: dic) { result, model, msg in
                if let _ = model {
                    
                }
            }
        }
    }
    
    @IBAction
    func addErrorBook() {
        guard let currentQ = currentQ else { return }
        let question = currentQ.question
        NetWork.request(currentQ.ifErrorBook == 0 ? .addErrorBook : .removeErrorBook,
                        modelType: NoneResponseData.self,
                        parameters: [currentQ.ifErrorBook == 0 ? "questionId" : "id": Int(question.id)]) { result, model, msg in
            if let _ = model {
                Toast(text: "操作成功", duration: 0.5).show()
                currentQ.ifErrorBook = currentQ.ifErrorBook == 0 ? 1 : 0
                self.addBtn.setTitle(currentQ.ifErrorBook == 0 ? "加入错题本" : "移除错题本", for: .normal)
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
    
    func getCourseAnalysis() {
        let dic = [
            "courseId" : courseId,
        ]
        NetWork.request(.getCourseAnalysis,
                        modelType: GetCourseAnalysisResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.items = model.analysisList.flatMap { $0.fileUrl.components(separatedBy: ",") }
                self.collectionView.reloadData()
                if self.items.count > 0 {
                    self.collectionView.scrollToItem(at: IndexPath(row: self.bookIndex - 1, section: 0), at: .left, animated: false)
                }
                if self.items.count == 0 {
                    self.collectHeightConstraint.constant = 0
                }
            }
        }
    }
    
    func customerService() {
        if WXApi.isWXAppInstalled() {
             let rep = WXOpenCustomerServiceReq()
             //这两个参数 可以照抄 第一个是固定的，第二个随意写
             rep.corpid = "wwca0150e67bdbe32a"
             rep.url = "https://work.weixin.qq.com/kfid/kfc2364c970f8a0bccf"
             WXApi.send(rep, completion: nil)

        }
    }
    
    @IBAction func order() {
        customerService()
        return
        
        var couponId: String? = nil
        if let data = detilsTwo, let detilsOne = detilsOne {
            if let coupon = data.coupon, detilsOne.price - coupon.discountAmount > 0 {
                couponId = coupon.couponId
            }
        }
        
        Router.push(.Pay(type: PayType.course(price: price, objectId: courseId, couponId: couponId, category: "1")), from: self)
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
    
    func getCourseTrialLearn(_ item: GetCourseDetilsItem?) {
        let dic = [
            "courseId" : courseId
        ]
        NetWork.request(.getCourseTrialLearn,
                        modelType: GetCourseTrialLearnResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                let count = (Double(model.userTryCount) ?? 0) - (Double(model.courseTryCount) ?? 0)
                self.tryBtn?.setTitle("已试听\(count > 0 ? model.courseTryCount : model.userTryCount)/\(model.courseTryCount)节，购买后解锁全部课程", for: .normal)
                if let item = item {
                    if Int(model.userTryCount) ?? 0 >= Int(model.courseTryCount) ?? 0 {
                        self.stop()
//                        self.study(item)
                    } else {
                        self.study(item)
                    }
                }
            }
        }
    }
}

extension CourseVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        
        cell.config(items[indexPath.row], selected: true, read: indexPath.row == bookIndex - 1)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let arr = items.compactMap { URL.init(string: $0)}
        
        let slider = PhotoSlider.ViewController(imageURLs: arr)
        slider.modalPresentationStyle = .overFullScreen
        slider.currentPage = indexPath.row
        present(slider, animated: true, completion: nil)
        slider.delegate = self
        
    }
}

extension CourseVC:PhotoSliderDelegate {
    func photoSliderControllerWillDismiss(_ viewController: ViewController) {
        bookIndex = viewController.currentPage + 1
        UserDefaults.standard.set(bookIndex, forKey: courseId)
        collectionView.reloadData()
    }
}

extension CourseVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 75, height: collectionView.bounds.height)
    }
}

