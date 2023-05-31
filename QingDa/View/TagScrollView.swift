//
//  TagScrollView.swift
//  PhoneRepair
//
//  Created by develop on 2022/10/16.
//

import UIKit

class TagScrollView: CommonView {
    var index = 0 {
        didSet {
            collectionView.reloadItems(at: [IndexPath(row: oldValue, section: 0), IndexPath(row: index, section: 0)])
        }
    }
    var tapAction: ((Int) -> Void)? = nil
    var scrollViewDidScroll: ((CGFloat) -> Void)? = nil
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [String] = [] {
        didSet {
            index = 0
        }
    }
    
    override func commonInit() {
        collectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        collectionView.collectionViewLayout = configureLayout()
    }
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
            
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(10), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(10), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        
        return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    }
}

extension TagScrollView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        cell.title.text = items[indexPath.row]
        cell.select = index == indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        tapAction?(indexPath.row)
    }
}

extension TagScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll?(scrollView.contentOffset.x)
    }
}
