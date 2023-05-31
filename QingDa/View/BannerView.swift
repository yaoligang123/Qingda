//
//  BannerView.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/2.
//

import UIKit

struct BannerList: Codable {
    var bannerUrl: String
}

class BannerView: CommonView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var bannerItems: [BannerList] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func commonInit() {
        collectionView.register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
    }
}

extension BannerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell

        cell.imageView.load(bannerItems[indexPath.row].bannerUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bannerItems.count
    }
}

extension BannerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
