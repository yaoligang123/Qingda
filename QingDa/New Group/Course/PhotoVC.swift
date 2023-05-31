//
//  PhotoVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/3.
//

import UIKit

class PhotoVC: UIViewController {
    
    var imageIndex = 0
    var images: [String] = []
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        
        collectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        
        banner.load(images[imageIndex])
    }


    override var shouldAutorotate:Bool{
        return false
    }
    
    @objc func close() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.dismiss(animated: false, completion: nil)
    }
}

extension PhotoVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.config(images[indexPath.row], radius: 2, selected: indexPath.row == imageIndex)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 38, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageIndex = indexPath.row
        banner.load(images[indexPath.row])
        
        collectionView.reloadData()
    }
}
