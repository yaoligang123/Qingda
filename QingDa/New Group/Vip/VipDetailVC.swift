//
//  VipDetailVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/30.
//

import UIKit
import Toaster

class VipDetailVC: UIViewController {
    
    var vipId: String = ""
    var appleId: String = ""
    var items: [SysVipDetilsJson] = []
    var data:SysVipDetilsResponse? = nil
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratio: NSLayoutConstraint!
    
    @IBOutlet weak var price:UILabel!
    @IBOutlet weak var thumbnail:UIImageView!
    @IBOutlet weak var buy:UIButton!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var sysAmount:UILabel!
    @IBOutlet weak var price2:UILabel!
    @IBOutlet weak var dateCount:UILabel!
    @IBOutlet weak var explains:UILabel!
    @IBOutlet weak var equities:UILabel!
    @IBOutlet weak var buyInform:UILabel!
    @IBOutlet weak var useInform:UILabel!
    
    @IBOutlet weak var progress:UIView!
    @IBOutlet weak var progressBar:UIView!
    @IBOutlet weak var bookView:UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        sysVipDetils()
    }
    
    func setUI() {
        self.title = "会员详情"
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 164)
        gradient.colors = [HEX("#FDECD9").cgColor, HEX("FEF4E8").cgColor, HEX("FFFFFF").cgColor]
        gradient.locations = [0, 0.57, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        collectionView.register(UINib(nibName: "JiaoFuCell", bundle: nil), forCellWithReuseIdentifier: "JiaoFuCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: PaySuccessNotification, object: nil)
    }
    
    func sysVipDetils() {
        NetWork.request(.sysVipDetils,
                        modelType: SysVipDetilsNowResponse.self,
                        parameters: ["vipId":vipId]) { result, model, msg in
            if let model = model {
                self.config(model.detils, model)
//                self.buy.setTitle(model.ifBuy == 0 ? "立即购买" : "已购买" , for: .normal)
//                self.buy.tag = model.ifBuy
                self.ratio.constant = CGFloat(model.surplusAmount) / CGFloat(model.sysAmount == 0 ? 1 : model.sysAmount) * self.progressBar.bounds.width
            }
        }
    }
    
    func config(_ data:SysVipDetilsResponse, _ model: SysVipDetilsNowResponse) {
        items = data.packageJson
        self.data = data
        let row = Int(items.count / 3)
        let height = (collectionView.bounds.width - 40) / 9 * 4 + 48
        heightConstraint.constant = CGFloat(row * 14 + (row + 1) * Int(height))
        collectionView.reloadData()
        name.text = data.name
        price.text = "¥\(data.price)/\(data.amount)套"
        sysAmount.text = "可选\(data.amount)套，永久入库"
        dateCount.text = "购买之日起\(data.dateCount)天内有效"
        explains.text = data.subtitle
        equities.text = data.equities
        buyInform.text = data.buyInform
        useInform.text = data.useInform
        price2.text = "¥\(data.price)"
        bookView.isHidden = data.category != "1"
        thumbnail.load(data.thumbnail)
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
        
        guard let data = data, buy.tag == 0 else {
            return
        }
        PKIAPHandler.shared.setProductIds(ids: [appleId])
        PKIAPHandler.shared.fetchAvailableProducts { [weak self](products)   in
           guard let self = self else {return}
            PKIAPHandler.shared.purchase(product: products[0]) { type, _, _ in
                Toast(text: type.message, duration: 3).show()
                if (type == .purchased) {
                    Toast(text: "支付成功", duration: 0.5).show()
                }
            }
        }
        
//        Router.push(.Pay(type: PayType.vip(price: data.price, vipId: data.vipId)), from: self)
//        orderVip(data.vipId)
    }
    
    @objc func refresh() {
        sysVipDetils()
    }
}

extension VipDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JiaoFuCell", for: indexPath) as! JiaoFuCell
        cell.config(items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension VipDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 40) / 3, height: (collectionView.bounds.width - 40) / 9 * 4 + 48)
    }
}
