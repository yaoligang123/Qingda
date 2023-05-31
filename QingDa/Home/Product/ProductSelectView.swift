//
//  ProductSelectView.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/8.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=8c2c76ab-49ae-4d64-b62b-6010c91fc7b2&fromEditor=true

import UIKit

class ProductSelectView: CommonView {
    
    var list:[SkuData] = []
    var data:GetProductDetilsData?
    var index = -1
    weak var vc:UIViewController?
    @IBOutlet weak var itemRow: ItemRow!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func commonInit() {
        super.commonInit()
        
        collectionView.register(UINib(nibName: "ProductSelectCell", bundle: nil), forCellWithReuseIdentifier: "ProductSelectCell")
    }
    
    func config(_ data:GetProductDetilsData) {
        self.data = data
        list = data.skuList
        collectionView.reloadData()
        itemRow.title.text = data.product.title
        itemRow.price.text = ""
        itemRow.reserve.text = "estoque："
        itemRow.thumbnail.load(data.product.thumbnail)
    }
    
    @IBAction
    func close() {
        self.isHidden = true
    }
    
    @IBAction
    func confirm() {
        guard isLogin() else {
            Router.present(.Login, from: vc!)
            return
        }
        if index >= 0 {
            if tag == 0 {
                addProductCar()
            } else {
                buy()
            }
        }
    }
    
    func addProductCar() {
        guard let data = data else { return }
        
        let dic = [
            "productId" : data.product.productId,
            "skuId" : data.skuList[index].skuId,
            "amount" : "1"
        ]
        vc?.startLoading()
        NetWork.request(.addProductCar,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                self.close()
            }
            self.vc?.stopLoading()
        }
    }
    
    func buy() {
        if let vc = vc, var data = data {
            data.skuList = [data.skuList[index]]
            Router.push(.OrderConfirmProduct(product: data), from: vc)
        }
    }
}

extension ProductSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductSelectCell", for: indexPath) as! ProductSelectCell
        cell.select = indexPath.row == index
        cell.disable = list[indexPath.row].reserve == "0"
        cell.btn.text = list[indexPath.row].norm
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
}

extension ProductSelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if list[indexPath.row].reserve != "0" {
            index = indexPath.row
            
            itemRow.price.text = kUnit + list[indexPath.row].newPrice
            itemRow.reserve.text = "estoque：" + list[indexPath.row].reserve
            collectionView.reloadData()
        }
    }
}

extension ProductSelectView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 20) / 3, height: 36)
    }
}
