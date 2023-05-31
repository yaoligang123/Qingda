//
//  Router.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/26.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=6d328495-8e8e-40d8-b7a6-c97e642c30c8&fromEditor=true


import Foundation
import UIKit
import Toaster

enum RouterPage {
    case ModifyPhone(openid: String, nickName: String, headimage: String)
    case Pay(type: PayType)
    case Doc(type: String)
    case Share
    case Photo(index: Int, images: [String])
    case Paper(type: Int)
    case ChangePhone(phone: String, pwd: Bool)
    case MyVipDetail(orderNumber: String)
    case AddBank(bank: BankListResponse?)
    case BankList(tap: ((BankListResponse) -> Void)?)
    case Money
    case Promote
    case MyVip
    case Coupon
    case Order
    case MyClass(type: Int)
    case Download
    case Vip
    case VipDetail(vipId: String, appleId: String)
    case MyInfo(type: Int)
    case Search
    case studyRecord
    case Course(courseId: String)
    case Course2(courseId: String)
    case FalseBook
    case Cart
    case Map(data: StoreData)
    case Study(id: String)
    case Select(type: SelectType)
    case SearchRepairResult(type: SelectType, word: String)
    case SubmitInfo(data: GetRepairPhoneData)
    case SubmitConfirm(items: [GetRepairModelDetilsData], data: GetRepairPhoneData)
    case SearchResult(word: String)
    case Product(productId: String)
    case SelectProduct
    case OrderConfirm(items:[CarDetils])
    case OrderConfirmProduct(product:GetProductDetilsData)
    case ProductOrder(data:ProductOrderData)
    case RepairOrder(data:String)
    case ServiceApply(data:ProductOrderData)
    case Refund(data:ProductOrderData, type:RefundType)
    
    case Login
    case Setting(userData: GetUserMessageData)
    case Bank(order:GetPayProductData, category:String)
    case Web(type: WebViewType)
    
    
    func vc() -> UIViewController {
        switch self {
        case let .ModifyPhone(openid, nickName, headimage):
            let vc = ChangePwdVC()
            vc.openid = openid
            vc.nickName = nickName
            vc.headimage = headimage
            return vc;
        case let .Pay(type):
            let vc = PayVC();
            vc.type = type
            return vc
        case let .Doc(type):
            let vc = DocVC();
            vc.type = type
            return vc
        case .Share:
            return ShareVC();
        case let .Photo(index, images):
            let vc = PhotoVC()
            vc.imageIndex = index
            vc.images = images
            return vc
        case let .Paper(type):
            let vc = PaperVC()
            vc.type = type
            return vc;
        case let .ChangePhone(phone, pwd):
            let vc = ChangePwdVC()
            vc.phone = phone
            vc.pwd = pwd
            return vc;
        case let .MyVipDetail(orderNumber):
            let vc = MyVipDetailVC()
            vc.orderNumber = orderNumber
            return vc
        case let .AddBank(bank):
            let vc = AddBankVC()
            vc.bank = bank
            return vc;
        case let .BankList(action):
            let vc = BankVC()
            vc.tapAction = action
            return vc;
        case .Money:
            return MoneyVC();
        case .Promote:
            return PromoteVC();
        case .MyVip:
            return MyVipVC();
        case .Coupon:
            return CouponVC();
        case .Order:
            return OrderVC();
        case let .MyClass(type):
            let vc = MyClassVC()
            vc.type = type
            return vc;
        case .Download:
            return DownloadVC();
        case .Vip:
            return VipVC()
        case let .VipDetail(vipId, appleId):
            let vc = VipDetailVC()
            vc.vipId = vipId
            vc.appleId = appleId
            return vc
        case let .MyInfo(type):
            let vc = MyInfoViewController()
            vc.type = type
            return vc
        case .Search:
            return SearchVC()
        case .studyRecord:
            return StudyRecordVC();
        case let .Course(courseId):
            let vc = CourseVC()
            vc.courseId = courseId
            return vc
        case let .Course2(courseId):
            let vc = Course2VC()
            vc.courseId = courseId
            return vc
        case .FalseBook:
            return FalseBookVC();
        case .Cart:
            return CartViewController()
        case let .Map(data):
            let vc = MapViewController()
            vc.data = data
            return vc
        case let .Study(id):
            let vc = StudyViewController()
            vc.studyId = id
            return vc
        case let .Select(type):
            let vc = SelectViewController()
            vc.type = type
            return vc
        case let .SearchRepairResult(type, word):
            let vc = SearchRepairResultController()
            vc.type = type
            vc.word = word
            return vc
        case let .SubmitInfo(data):
            let vc = SubmitInfoViewController()
            vc.data = data
            return vc
        case let .SubmitConfirm(items, data):
            let vc = SubmitConfirmViewController()
            vc.items = items
            vc.data = data
            return vc
        case let .SearchResult(word):
            let vc = SearchResultViewController()
            vc.word = word
            return vc
        case let .Product(productId):
            let vc = ProductViewController()
            vc.productId = productId
            return vc
        case .SelectProduct:
            return SelectProductViewController()
        case let .OrderConfirm(items):
            let vc = OrderConfirmViewController()
            vc.items = items
            return vc
        case let .OrderConfirmProduct(product):
            let vc = OrderConfirmViewController()
            vc.product = product
            return vc
        case let .RepairOrder(data):
            let vc = RepairOrderViewController()
            vc.data = data
            return vc
        case let .ProductOrder(data):
            let vc = ProductOrderViewController()
            vc.data = data
            return vc
        case let .ServiceApply(data):
            let vc = ServiceApplyViewController()
            vc.data = data
            return vc
        case let .Refund(data, type):
            let vc = RefundViewController()
            vc.data = data
            vc.type = type
            return vc
        case .Login:
            return LoginVC()
        case let .Setting(userData):
            let vc = SettingViewController()
            vc.userData = userData
            return vc
        case let .Bank(order, category):
            let vc = BankViewController()
            vc.order = order
            vc.category = category
            return vc
        case let .Web(type):
            let vc = WebViewController()
            vc.type = type
            return vc
        }
    }
}

let NeedLoginPage:[RouterPage] = [
    .Cart
]

class Router {
    static func push(_ page: RouterPage, from: UIViewController) {
        var needLogin = true
        switch page {
//        case .Vip:
//            Toast(text: "暂未开放", duration: 0.5).show()
//            return
        case .Search, .ModifyPhone:
            needLogin = false
            default: break
        }
        if needLogin && !isLogin() {
            Router.present(.Login, from: from)
            return
        }
        let vc = page.vc()
        vc.hidesBottomBarWhenPushed = true
        if #available(iOS 14.0, *) {
            from.navigationItem.backButtonDisplayMode = .minimal
        } else {
            from.navigationItem.backButtonTitle = " "
        }
        
        
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func present(_ page: RouterPage, from: UIViewController, animated:Bool = true) {
        let vc = page.vc()
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: IMAGE("组 56815").withRenderingMode(.alwaysOriginal), style: .plain, target: vc, action: NSSelectorFromString("close"))
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        from.present(nav, animated: animated, completion: nil)
    }
}
