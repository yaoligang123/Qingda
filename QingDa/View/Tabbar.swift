//
//  Tabbar.swift
//  PhoneRepair
//
//  Created by develop on 2022/8/11.
//

import UIKit

class Tabbar: UICollectionView {
    
    var selectedIndex = 0
    
    var items: [String] = [] {
        didSet {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: kScreenW, height: bounds.size.height)
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        common()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        common()
    }
    
    func common() {
        delegate = self
        dataSource = self
        register(UINib(nibName: "TabbarCell", bundle: nil), forCellWithReuseIdentifier: "TabbarCell")
    }
}

extension Tabbar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabbarCell", for: indexPath) as! TabbarCell
        cell.titleLabel.text = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.titleLabel.textColor = isSelected ? HEX(kMainColor2) : HEX(kMainColor3)
        cell.bottomLine.isHidden = !isSelected
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
}

extension Tabbar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        reloadData()
    }
}

class TabbarFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        common()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }
    
    func common() {
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 20
        self.minimumLineSpacing = 20
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var width = 0.0
        attributes?.forEach { layoutAttribute in
            width += layoutAttribute.bounds.width
        }

        if let attributes = attributes, attributes.count > 1, attributes[0].size.width > 1 {
            var space = (collectionView?.bounds.width ?? 0) - width
            if space > 0 {
                space = floor(space / Double(attributes.count - 1))

                var leftMargin = 0.0
                attributes.forEach { layoutAttribute in
                    layoutAttribute.frame.origin.x = leftMargin
                    leftMargin += (layoutAttribute.bounds.width + space)
                }
            }
        }

        return attributes
    }
}
