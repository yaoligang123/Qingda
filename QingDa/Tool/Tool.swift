//
//  Tool.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/12.
//

import Foundation
import Toaster

let formatter = DateFormatter()

var gStore:StoreData?
var gReturn:GetReturnMessageData?

func stringFromRepairState(_ state: String) -> String {
    if state == "1" {
        return ""
    } else if state == "2" {
        return "Aguardando reparo"
    } else if state == "3" {
        return "Porta em porta"
    } else if state == "4" {
        return "Finalizar"
    }
    return ""
}

func stringFromProductState(_ state: String) -> String {
    if state == "1" {
        return "Aguardando \npagamento"
    } else if state == "2" {
        return "Aguardando o envio"
    } else if state == "3" {
        return "Aguardando o\n recebimento"
    } else if state == "4" {
        return "Concluído"
    } else if state == "5" {
        return ""
    }
    return ""
}

var gTab:UITabBarController?

var gOrder:OrderViewController?

var gToken = UserDefaults.standard.string(forKey: "gToken")

var gGrade = UserDefaults.standard.string(forKey: "gGrade")
var gProvince = UserDefaults.standard.string(forKey: "gProvince")
var gCity = UserDefaults.standard.string(forKey: "gCity")

func orderVip(_ vipId:String, _ payType:String) {
    NetWork.request(.createVipOrder,
                    modelType: CreateVipOrderResponse.self,
                    parameters: ["vipId": vipId]) { result, model, msg in
        if let model = model {
            initiatePay(orderNumber: model.orderNumber, category: "1", payType: payType)
        }
    }
}

//1:课程订单2:试卷订单
func createCourseOrder(objectId:String, couponId:String?, category:String,  payType:String) {
    var dic = [
        "objectId" : objectId,
        "category" : category,
    ]
    
    if let couponId = couponId {
        dic["couponId"] = couponId
    }
    
    NetWork.request(.createCourseOrder,
                    modelType: CreateVipOrderResponse.self,
                    parameters: dic) { result, model, msg in
        if let model = model {
            initiatePay(orderNumber: model.orderNumber, category: "2", payType: payType)
        }
    }
}


let PaySuccessNotification = NSNotification.Name(rawValue: "PaySuccessNotification")

func callbackTest(orderNumber: String, category: String) {
    let dic = [
        "orderNumber" : orderNumber,
        "category" : category
    ]
    NetWork.request(.callbackTest,
                    modelType: NoneResponseData.self,
                    parameters: dic) { result, model, msg in
        if let _ = model {
            NotificationCenter.default.post(name: PaySuccessNotification, object: nil)
            Toast(text: "购买成功", duration: 0.5).show()
        }
    }
}

//category 1:会员订单2:课程(试卷)订单
//payType 1:微信APP、2:支付宝APP、3:微信H5、4:支付宝H5、5：微信公众号H5
func initiatePay(orderNumber: String, category: String, payType: String) {
    callbackTest(orderNumber:orderNumber, category: category)
    return
    let dic = [
        "orderNumber" : orderNumber,
        "category" : category,
        "payType" : payType
    ]
    NetWork.request(.initiatePay,
                    modelType: InitiatePayResponse.self,
                    parameters: dic) { result, model, msg in
        if let model = model {
            AlipaySDK.defaultService().payOrder(model.detils, fromScheme: "jingkeysAliPay", callback: { (resultDic) in
                if let resultDic = resultDic as? NSDictionary {
                    if let resultStatus = resultDic["resultStatus"] as? String {
                        if(Int(resultStatus) == 9000) {
                            callbackTest(orderNumber:orderNumber, category: category)
                            return
                        }
                    }
                }
                Toast(text: "支付失败", duration: 0.5).show()
            })
        }
    }
}

func saveGrade(_ grade: String) {
    gGrade = grade
    UserDefaults.standard.set(grade, forKey: "gGrade")
}

func saveProvince(_ province: String) {
    gProvince = province
    UserDefaults.standard.set(province, forKey: "gProvince")
}

func saveCity(_ city: String) {
    gCity = city
    UserDefaults.standard.set(city, forKey: "gCity")
}

func getGrade(_ grade: String, _ semester: String) -> String {
    if grade.isEmpty {
        return ""
    } else {
        if semester == "1" {
            return grade + "上学期"
        } else if semester == "2" {
            return grade + "下学期"
        } else {
            return grade + "全学期"
        }
    }
}


func isLogin() -> Bool {
    if let token = gToken, !token.isEmpty {
        return true
    }
    return false
}

func tel() {
    if let gReturn = gReturn, let tel = URL.init(string: "tel://" + gReturn.returnPhone) {
        UIApplication.shared.open(tel)
    }
}

func statusBarHeight() -> CGFloat {
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

func createQRForString(qrString: String?, qrImageName: String) -> UIImage?{
    if let sureQRString = qrString {
        let stringData = sureQRString.data(using: .utf8,
                                           allowLossyConversion: false)
        // 创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter.outputImage
         
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
         
        // 返回二维码image
        let codeImage = UIImage(ciImage: colorFilter.outputImage!
            .transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
         
        // 通常,二维码都是定制的,中间都会放想要表达意思的图片
        if let backImage = UIImage(named: qrImageName) {
            let rect = CGRect(x:0, y:0, width:backImage.size.width,
                              height:backImage.size.height)
            UIGraphicsBeginImageContext(rect.size)

            backImage.draw(in: rect)
            let qrSize = CGSize(width:150,
                                    height:150)
            codeImage.draw(in: CGRect(x: 0, y: 0, width:qrSize.width,
                                      height:qrSize.height))
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()
            return resultImage
        }
        return codeImage
    }
    return nil
}
