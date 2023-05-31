//
//  HomeViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/19.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=5c14da3e-49b6-4ebe-aed6-07005f1fb14b&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&fromEditor=true

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    var fromPay = false
    var pageNumber = 1
    let pageSize = 10
    let defaultImage = "组 57032"
    
    var bannerItems: [BannerListData] = []
    var storeItems: [StoreData] = []
    var studyItems: [StudyData] = []
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getIndexMessageOne()
        pageNumber = 1
        self.getIndexMessageTwo()
        self.getReturnMessage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let header = tableView.tableHeaderView {
            let maxY = stackView.frame.maxY
            var rect = header.frame
            rect.size.height = maxY
            header.frame = rect
            tableView.tableHeaderView = header
        }
        
        if fromPay {
            gTab?.selectedIndex = 1
            fromPay = false
        }
    }
    
    func setUI() {
        tableView.register(UINib(nibName: "HomeStoreCell", bundle: nil), forCellReuseIdentifier: "HomeStoreCell")
        tableView.register(UINib(nibName: "HomeTechCell", bundle: nil), forCellReuseIdentifier: "HomeTechCell")
        tableView.register(UINib(nibName: "HomeHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeader")
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            guard let self = self, self.studyItems.count > 0 else { return }
            self.getIndexMessageTwo()
        })
        
        collectionView.register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
        
        searchBar.searchAction = { [weak self] (word) in
            guard let self = self else { return }
            Router.push(.SearchResult(word: word), from: self)
        }
        
        self.navigationItem.title = "Assistência técnica celular"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: IMAGE("组 57052").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(goCart))
    }
    
    func getReturnMessage() {
        if gReturn != nil { return }
        NetWork.request(.getReturnMessage,
                        modelType: GetReturnMessageData.self,
                        parameters: [:]) { result, model, msg in
            if let model = model {
                gReturn = model
            }
        }
    }
        
    func getIndexMessageOne() {
        NetWork.request(.getIndexMessageOne,
                        modelType: GetIndexMessageOneData.self,
                        parameters: [:]) { result, model, msg in
            if let model = model, model.bannerList.count > 0 {
                self.bannerItems = model.bannerList
            } else {
                if self.bannerItems.count == 0 {
                    self.bannerItems = [BannerListData(bannerId: "", bannerUrl: self.defaultImage)]
                }
            }
            self.collectionView.reloadData()
            
            if let model = model, !model.store.storeId.isEmpty {
                self.storeItems = [model.store]
                gStore = model.store
                self.tableView.reloadData()
            }
        }
    }
    
    func getIndexMessageTwo() {
        let dic = [
            "pageNumber" : String(pageNumber),
            "pageSize" : String(pageSize)
        ]
        NetWork.request(.getIndexMessageTwo,
                        modelType: GetIndexMessageTwoData.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                if model.list.count > 0 {
                    if self.pageNumber == 1 {
                        self.studyItems = model.list
                    } else {
                        self.studyItems += model.list
                    }
                    self.pageNumber += 1
                    
                    self.tableView.reloadData()
                    self.tableView.mj_footer?.endRefreshing()
                } else {
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
            } else {
                self.tableView.mj_footer?.endRefreshing()
            }
        }
    }
    
    @IBAction
    func goSelect(btn: UIButton) {
        Router.push(.Select(type: btn.tag == 0 ? .SelectPhoneTypePhone : .SelectPhoneTypePC), from: self)
    }
    
    @IBAction
    func goProduct() {
        Router.push(.SelectProduct, from: self)
    }
    
    @objc
    func goCart() {
        Router.push(.Cart, from: self)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return storeItems.count
        } else if section == 1 {
            return studyItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeStoreCell", for: indexPath) as! HomeStoreCell
            cell.config(storeItems[indexPath.row])
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTechCell", for: indexPath) as! HomeTechCell
            cell.config(studyItems[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 81
        } else {
            return 58
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeader") as! HomeHeader
        if section == 0 {
            header.title.text = "Serviço em loja"
            header.subTitle.text = "Loja física"
            header.subTitle.isHidden = false
        } else {
            header.title.text = "Dica do dia"
            header.subTitle.text = ""
            header.subTitle.isHidden = true
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            Router.push(.Map(data: storeItems[indexPath.row]),
                        from: self)
        } else if indexPath.section == 1 {
            Router.push(.Study(id: studyItems[indexPath.row].studyId),
                        from: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        if bannerItems[indexPath.row].bannerUrl == defaultImage {
            cell.imageView.image = IMAGE(defaultImage)
        } else {
            cell.imageView.load(bannerItems[indexPath.row].bannerUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bannerItems.count
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
