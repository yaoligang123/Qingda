//
//  ViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/19.
//

import UIKit

class TabViewController: UITabBarController {
    
    let tabTitle = ["教辅", "试卷", "消息", "我的"]
    let unselectedImg = ["组 61220", "组 61221", "组 61222", "组 61223"]
    let selectedImg = ["组 61227", "组 61340", "组 61225", "组 61224"]
    let paper = PaperVC()
    let me = MeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let order = OrderViewController()
        gOrder = order
        let controllers = [JiaoFuVC(), paper, MessageVC(), me]
        
        for (i, item) in controllers.enumerated() {
            addChildVC(childVC: item,
                       title: tabTitle[i],
                       unselectedImg: unselectedImg[i],
                       selectedImg: selectedImg[i])
        }
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = HEX("EEEEEE")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: HEX(kMainColor1)]
        self.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = appearance
        } else {
            self.tabBar.backgroundColor = .white
        }
        
            
        gTab = self
        delegate = self
    }
    
    func addChildVC(childVC: UIViewController,
                    title: String,
                    unselectedImg: String,
                    selectedImg: String) {

        var img = UIImage(named: unselectedImg)
        img = img?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        var selectedImg = UIImage(named:selectedImg)
        selectedImg = selectedImg?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        childVC.tabBarItem.image = img
        childVC.tabBarItem.selectedImage = selectedImg
        childVC.title = title

        let nav = UINavigationController(rootViewController: childVC)
        
        addChild(nav)
    }
}

extension TabViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Pedido" {
            NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let vc = viewController as? UINavigationController, vc.topViewController == paper && !isLogin() {
            Router.present(.Login, from: self)
            return false
        }
        
        if let vc = viewController as? UINavigationController, vc.topViewController == me && !isLogin() {
            Router.present(.Login, from: self)
            return false
        }
        return true
    }
}

