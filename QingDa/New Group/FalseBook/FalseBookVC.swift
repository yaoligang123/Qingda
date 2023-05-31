//
//  FalseBookVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/26.
//

import UIKit
import Toaster

class FalseBookVC: UIViewController {
    
    let sub = ["语文","数学","英语","物理","化学","生物","政治","历史","地理"]
    let dic = ["语文":"组 62056","数学":"组 62057","英语":"组 62058","物理":"组 62059","化学":"组 62060","生物":"组 62061","政治":"组 62062","历史":"组 62063","地理":"组 62064"]
    
    var images:[String] = []
    var items: [GetErrorBookSujectCountResponse] = []
    var records: [GetMyCourseItem] = []
    @IBOutlet weak var collectionView0: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getMyCourse()
        
        generate()
    }
    
    func generate() {
        items = sub.map {
            GetErrorBookSujectCountResponse(suject: $0,
                                            image: dic[$0] ?? "",
                                            sujectCount: "0")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        getErrorBookSujectCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setUI() {
        self.title = "错题本"
        
        collectionView.register(UINib(nibName: "FalseBookCell", bundle: nil), forCellWithReuseIdentifier: "FalseBookCell")
        
        collectionView0.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
    }
    
    func getErrorBookSujectCount() {
        NetWork.request(.getErrorBookSujectCount,
                        modelType: [GetErrorBookSujectCountResponse].self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                self.generate()
                model.forEach { item in
                    let value = self.items.first {
                        item.suject == $0.suject
                    }
                    value?.sujectCount = item.sujectCount
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func getMyCourse() {
        NetWork.request(.getMyCourse,
                        modelType: GetMyCourseResponse.self,
                        parameters: [
                            "category": "2",
                            "pageNumber" : 1,
                                     "pageSize" : 100]) { result, model, msg in
            if let model = model {
                self.records = model.records
                self.images = model.records.map { $0.thumbnail }
                self.collectionView0.reloadData()
            }
        }
    }
    
    @IBAction func viewAll() {
        Router.push(.MyClass(type: 0), from: self)
    }
}

extension FalseBookVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            cell.config(images[indexPath.row])

            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FalseBookCell", for: indexPath) as! FalseBookCell
        cell.config(items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView0 {
            return images.count
        }
        return items.count;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView0 {
            return CGSize(width: 87, height: collectionView.bounds.height)
        }
        return CGSize(width: (collectionView.bounds.width - 16) / 3, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if items[indexPath.row].sujectCount == "0" {
                Toast(text: "暂无错题，请去教辅课程中添加", duration: 0.5).show()
                return
            }
            Router.push(.Web(type: .cuoti(subject: items[indexPath.row].suject)),
                        from: self)
        } else {
            let courseId = records[indexPath.row].objectId
            let vc = records[indexPath.row].category == "1" ? RouterPage.Course2(courseId: courseId) : RouterPage.Course(courseId: courseId)
            Router.push(vc, from: self)
        }
    }
}
