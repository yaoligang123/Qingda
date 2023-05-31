//
//  ProductViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/1.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=d30ebef3-1e24-4bc5-a80f-4a112ba094c2&fromEditor=true

import UIKit
import WebKit

class ProductViewController: UIViewController {
    
    var productId = ""
    var bannerItems: [String] = []
    var data:GetProductDetilsData?
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var web: WKWebView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectView: ProductSelectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        getProductDetils()
    }
    
    func setUI() {
        self.title = "Descrição do produto"
        
        cartBtn.layer.borderWidth = 1
        cartBtn.layer.borderColor = HEX(kMainColor1).cgColor
        cartBtn.layer.cornerRadius = 15
        cartBtn.layer.masksToBounds = true
        
        container.layer.borderWidth = 1
        container.layer.borderColor = HEX(kMainColor1).cgColor
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = true
        
        bottom.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
        bottom.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottom.layer.shadowOpacity = 1
        bottom.layer.shadowRadius = 4
        
        collectionView.register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
    }

    func getProductDetils() {
        let dic = [
            "productId" :productId
        ]
        startLoading(transparent: false)
        NetWork.request(.getProductDetils,
                        modelType: GetProductDetilsData.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.data = model
                self.config()
                self.stopLoading()
            } else {
                self.showError()
            }
        }
    }
    
    func config() {
        if let data = data {
            titleLabel.text = data.product.title
            if data.skuList.count > 0 {
                priceLabel.text = kUnit + data.skuList[0].newPrice
            }
            web.loadHTMLString(data.product.content, baseURL: nil)
            thumbnail.load(data.product.thumbnail)
            bannerItems = data.product.banners.components(separatedBy: ",")
            if bannerItems.count > 0 {
                thumbnail.isHidden = true
            } else {
                collectionView.isHidden = true
            }
            collectionView.reloadData()
            selectView.config(data)
        }
    }
    
    @IBAction
    func addCart(btn:UIButton) {
        selectView.isHidden = false
        selectView.tag = btn.tag
        selectView.vc = self
    }
    
    @IBAction
    func goCart() {
        Router.push(.Cart, from: self)
    }
}

extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.imageView.load(bannerItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bannerItems.count
    }
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
