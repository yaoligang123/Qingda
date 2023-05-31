//
//  NibLoadable.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

import UIKit

protocol NibLoadable {
}

extension NibLoadable where Self : UIView {
    func loadFromNib(_ nibname: String? = nil) {
        //self(小写) 当前对象
        let loadName = nibname == nil ? String(describing: type(of: self)) : nibname!
        
        let view = Bundle.main.loadNibNamed(loadName, owner: self, options: nil)?.first as? UIView
        if let view = view {
            view.frame = self.bounds
            if view.translatesAutoresizingMaskIntoConstraints {
                view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            } else {
                view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            }
            
            self.addSubview(view)
        }
    }
}

protocol BottomLine {
}

extension BottomLine where Self : UIView {
    func drawLine(_ rect: CGRect, lineHeight: CGFloat, color: String) {
        guard let content = UIGraphicsGetCurrentContext() else { return }
        content.setFillColor(HEX(color).cgColor)
        content.fill(CGRect.init(x: 0, y: self.frame.height - lineHeight, width: self.frame.width, height: lineHeight))
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
    }
}

extension UIView {

     public func filletedCorner(_ cornerRadii:CGSize,_ roundingCorners:UIRectCorner)  {
          let fieldPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii:cornerRadii)
          let fieldLayer = CAShapeLayer()
          fieldLayer.frame = bounds
          fieldLayer.path = fieldPath.cgPath
          self.layer.mask = fieldLayer
    }
}

extension UIStackView {
    func removeAll() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

extension UIImageView {
    func load(_ url:String, placeholder:UIImage? = nil) {
        var model = url
        if model.hasPrefix("/") {
            model = NetWork.baseURL + model
        }
        self.kf.setImage(with: URL(string: model), placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
    }
}

extension UIViewController {
    func startLoading(transparent:Bool = true) {
        let loadView = LoadView()
        loadView.tag = 1000
        if !transparent {
            loadView.backgroundColor = .white
        }
        loadView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadView)
        loadView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loadView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        loadView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        loadView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        loadView.indicator.startAnimating()
    }
    
    func stopLoading() {
        if let view = self.view.viewWithTag(1000) {
            view.removeFromSuperview()
        }
    }
    
    func showError() {
        if let view = self.view.viewWithTag(1000) as? LoadView {
            view.indicator.stopAnimating()
            view.error.isHidden = false
        }
    }
}

extension Array where Element == String {
    func filterEmpty() -> Array {
        filter { !$0.isEmpty }
    }
}

func getCurrentViewController(base: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController ) -> UIViewController? {
    if let nav = base as? UINavigationController {
        return getCurrentViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        return getCurrentViewController(base: tab.selectedViewController)
    }
    if let presented = base?.presentedViewController {
        return getCurrentViewController(base: presented)
    }
    return base
}
