//
//  AppDelegate.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/19.
//

import UIKit
import IQKeyboardManagerSwift
import Toaster
import Alamofire
import CleanJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        let backImg = UIImage.init(named: "组 56401")?.withRenderingMode(.alwaysOriginal)
        
        let app = UINavigationBarAppearance()
//        app.configureWithOpaqueBackground()
//        app.backgroundColor = .white
        app.configureWithTransparentBackground()
        app.setBackIndicatorImage(backImg, transitionMaskImage: backImg)
        app.shadowImage = nil
        app.shadowColor = nil

        UINavigationBar.appearance().standardAppearance = app
        UINavigationBar.appearance().scrollEdgeAppearance = app
        
        window = UIWindow(frame: CGRect(x: 0,
                                        y: 0,
                                        width: kScreenW,
                                        height:kScreenH))
        window?.backgroundColor = UIColor.white
        window?.rootViewController = TabViewController()
        window?.makeKeyAndVisible()
        
        ToastView.appearance().bottomOffsetPortrait = 150
        
        WXApi.registerApp("wxa0f3de03e0f3e27f", universalLink: "https://app.jingkeys.com/apple-app-site-association")
        
//        AliPrivateService.initLicense()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        WXApi.handleOpen(url, delegate: self)
        return true
    }
            
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        WXApi.handleOpen(url, delegate: self)
        return true
    }
            
    func application(_ application: UIApplication, continue userActivity:
        NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    func onResp(_ resp: BaseResp) {
        if resp.isKind(of: PayResp.self) {
        }  else if resp.isKind(of: SendAuthResp.self) {
            
            let aresp = resp as! SendAuthResp
            DispatchQueue.main.async {
                if aresp.errCode == 0 {
                    if let code = aresp.code {
                        self.oauth2(code)
                    }
                    else {
                    }
                }
                else {
                }
            }
        }
    }
    
    func appLoginByOpneid(_ wechat: WechatResponse) {
        NetWork.request(.appLoginByOpneid,
                        modelType: AppLoginByOpneidResponse.self,
                        parameters: ["openid": wechat.openid]) { result, model, msg in
            if let model = model {
                if model.ifExist == 0 {
                    self.userinfo(wechat)
                } else if !model.token.isEmpty {
                    UserDefaults.standard.set(model.token, forKey: "gToken")
                    gToken = model.token
                    let vc = getCurrentViewController()
                    vc?.dismiss(animated: true)
                }
            }
        }
    }
    
    func oauth2(_ code: String) {
        let url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxa0f3de03e0f3e27f&secret=8ad7ea91c996efed5ea4fb39bd8ddb02&code=\(code)&grant_type=authorization_code"
        AF.request(url,
                   method: .post,
                   parameters: [:],
                   encoding: JSONEncoding.default,
                   headers: nil).responseDecodable(of:WechatResponse.self, decoder: CleanJSONDecoder()) { (data) in
            if let value = data.value {
                self.appLoginByOpneid(value)
            }
        }
    }
    
    func userinfo(_ wechat: WechatResponse) {
        let url = "https://api.weixin.qq.com/sns/userinfo?access_token=\(wechat.access_token)&openid=\(wechat.openid)"
        AF.request(url,
                   method: .post,
                   parameters: [:],
                   encoding: JSONEncoding.default,
                   headers: nil).responseDecodable(of:WechatUserResponse.self, decoder: CleanJSONDecoder()) { (data) in
            if let value = data.value {
                let vc = getCurrentViewController()
                if let vc = vc {
                    Router.push(.ModifyPhone(openid: wechat.openid, nickName: value.nickname, headimage: value.headimgurl), from: vc)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        .portrait
    }
}

