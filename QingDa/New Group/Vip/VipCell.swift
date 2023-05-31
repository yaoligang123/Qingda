//
//  VipCell.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import UIKit

class VipCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var buy: UIButton!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var lineWidth: NSLayoutConstraint!
    var data: SysVipListResponse? = nil
    var images:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowRadius = 3
        
        collectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
    }

    func config(_ data: SysVipListResponse) {
        self.data = data
        let color = data.category == "1" ? HEX("#985A33") : HEX("#983336")
        let btnColor = data.category == "1" ? HEX("#D7A35F") : HEX("#EE847C")
        name.text = data.name
        subtitle.text = data.subtitle
        price.text = "¥\(data.price)"
        
        name.textColor = color
        subtitle.textColor = color
        price.textColor = color
        buy.backgroundColor = btnColor
//        buy.setTitle(data.ifBuy == "0" ? "立即购买" : "已购买", for: .normal)
        bgImage.image = data.category == "1" ? IMAGE("组 62023") : IMAGE("组 62024")
        bgImage.load(data.thumbnail, placeholder: data.category == "1" ? IMAGE("组 62023") : IMAGE("组 62024"))
        
        images = data.packageJson
        collectionView.reloadData()
    }
    
    func config(_ data: GetMyVipOrderListItem, _ index: Int) {
        name.text = data.sysName
        subtitle.text = data.sysSubtitle
        price.text = "¥\(data.price)"
        
        let color = HEX("#985A33")
        let btnColor = HEX("#D7A35F")
        name.textColor = color
        subtitle.textColor = color
        price.textColor = color
        buy.backgroundColor = btnColor
        bgImage.load(data.sysThumbnail)
        
        buy.isHidden = false
        if index == 0 {
            buy.setTitle("立即使用\(data.surplusAmount)/\(data.sysAmount)", for: .normal)
        } else if index == 1 {
            buy.setTitle("兑换详情", for: .normal)
        } else {
            buy.isHidden = true
        }
        
        lineWidth.constant = (bgImage.bounds.width - 32.0) * (Double(data.surplusAmount) ?? 0) / (Double(data.sysAmount) ?? 1)
        images = data.sysPackageJson
    }
    
    @IBAction func order() {
        if let data = data{
//            orderVip(data.vipId)
        }
    }
    
}

extension VipCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.config(images[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
}

extension VipCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 40.5, height: collectionView.bounds.height)
    }
}
