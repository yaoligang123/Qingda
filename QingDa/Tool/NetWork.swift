//
//  NetWork.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/5.
//

import Foundation
import Alamofire
import CleanJSON
import Toaster

enum EndPoint: String {
    case downTestPaper = "/paper/private/downTestPaper"
    case getPlayInfoWithOptions = "/upload/public/getPlayInfoWithOptions"
    case bindPhone = "/login/public/bindPhone"
    case appLoginByOpneid = "/login/public/appLoginByOpneid"
    case downErrorBook = "/errorbook/private/downErrorBook"
    case getCourseTrialLearn = "/index/private/getCourseTrialLearn"
    case submitStudyRecordDirectory = "/index/private/submitStudyRecordDirectory"
    case updateMessageState = "/index/private/updateMessageState"
    case getSujectRelation = "/login/public/getSujectRelation"
    case updateStudyTimeCount = "/index/private/updateStudyTimeCount"
    case getMyTestPaper = "/my/private/getMyTestPaper"
    case killMe = "/my/private/killMe"
    case messageList = "/index/private/messageList"
    case updateUserMessage = "/my/private/updateUserMessage"
    case getQuestionAnalyse = "/errorbook/private/getQuestionAnalyse"
    case updatePhone = "/my/private/updatePhone"
    case updatePassword = "/my/private/updatePassword"
    case chooseCourse = "/my/private/chooseCourse"
    case getMyVipOrderDetils = "/my/private/getMyVipOrderDetils"
    case addBank = "/promoter/private/addBank"
    case updateBank = "/promoter/private/updateBank"
    case deleteBank = "/promoter/private/deleteBank"
    case applyTixian = "/promoter/private/applyTixian"
    case bankList = "/promoter/private/bankList"
    case promoterMoney = "/promoter/private/promoterMoney"
    case createCourseOrder = "/order/private/createCourseOrder"
    case getMyVipOrderList = "/my/private/getMyVipOrderList"
    case callbackTest = "/pay/public/callbackTest"
    case initiatePay = "/pay/private/initiatePay"
    case createVipOrder = "/order/private/createVipOrder"
    case sysVipDetils = "/my/private/sysVipDetilsNow"
    case coupon = "/my/private/coupon"
    case getMyOrderCourseList = "/my/private/getMyOrderCourseList"
    case getMyCoursePage = "/my/private/getMyCoursePage"
    case addBookcase = "/index/private/addBookcase"
    case deleteBookcase = "/index/private/deleteBookcase"
    case getRecommend = "/index/public/getRecommend"
    case sendCode = "/login/public/sendCode"
    case getSys = "/login/public/getSys"
    case appLoginByPhone = "/login/public/appLoginByPhone"
    case getMuchSys = "/login/public/getMuchSys"
    case appLoginByPassword = "/login/public/appLoginByPassword"
    
    case getBanner = "/index/public/getBanner"
    case searchCourse = "/index/public/searchCourse"
    
    case getMyDown = "/my/private/getMyDown"
    case sysVipList = "/my/private/sysVipList"
    case getUserMessage = "/my/private/getUserMessage"
    case getMyCourse = "/index/private/getMyCourse"
    case courseDetilsOne = "/index/private/courseDetilsOne"
    case courseDetilsTwo = "/index/private/courseDetilsTwo"
    case courseDetilsThree = "/index/private/courseDetilsThree"
    case getCourseAnalysis = "/index/private/getCourseAnalysis"
    case getPaperList = "/paper/private/getPaperList"
    case getPaperDetils = "/paper/private/getPaperDetils"
    case getErrorBookSujectCount = "/errorbook/private/getErrorBookSujectCount"
    case addErrorBook = "/errorbook/private/addErrorBook"
    case removeErrorBook = "/errorbook/private/removeErrorBook"
    case getStudyRecordList = "/my/private/getStudyRecordList"
    case addStudyRecord = "/index/private/addStudyRecord"
    
    case getProductByType = "/appUser/mall/private/getProductByType"
    
    //获取临时登录token
    case getToken = "/appUser/login/public/getToken"
    
    case getReturnMessage = "/index/public/getReturnMessage"
    
    case getIndexMessageOne = "/index/public/getIndexMessageOne"
    case getIndexMessageTwo = "/index/public/getIndexMessageTwo"
    
    case getStudyDetils = "/index/public/getStudyDetils"
    case addProductCar = "/car/private/addProductCar"
    case carDetils = "/car/private/carDetils"
    case updateCarAmount = "/car/private/updateCarAmount"
    case deleteCar = "/car/private/deleteCar"
    
    case getRepairPhone = "/index/public/getRepairPhone"
    case getRepairModel = "/index/public/getRepairModel"
    case getRepairModelDetils = "/index/public/getRepairModelDetils"
    
    case getProductType = "/index/public/getProductType"
    case getProductList = "/index/public/getProductList"
    case getProductDetils = "/index/public/getProductDetils"
    
    case uploadImage = "/upload/public/uploadImage"
    
    case getAddressList = "/car/private/getAddressList"
    case updateAddress = "/car/private/updateAddress"
    case addAddress = "/car/private/addAddress"
    case deleteAddress = "/car/private/deleteAddress"
    case getDelAddress = "/car/private/getDelAddress"
    
    case productOrderUpdate = "/my/private/productOrderUpdate"
    case payProduct = "/order/private/payProduct"
    case payProductByCar = "/order/private/payProductByCar"
    case createServerOrder = "/order/private/createServerOrder"
    case getProductOrderList = "/my/private/getProductOrderList"
    case getOrderDetils = "/order/private/getOrderDetils"
    case getServerOrderDetils = "/order/private/getServerOrderDetils"
    case getServerOrderList = "/my/private/getServerOrderList"
    case serverOrderUpdate = "/my/private/serverOrderUpdate"
    case initiatePayment = "/order/private/initiatePayment"
    
    case getOrderAfterSaleDetils = "/return/private/getOrderAfterSaleDetils"
    case orderAfterSale = "/return/private/orderAfterSale"
    case saveOrderAfterExpress = "/return/private/saveOrderAfterExpress"
    case againApplyReturn = "/return/private/againApplyReturn"
    
    case login = "/login/public/login"
    case quit = "/login/private/quit"
    case getAboutUs = "/my/public/getAboutUs"
}

enum HTTPResultType {
    case success
    case failure
}

struct ResponseData<T: Codable>: Codable {
    var msg: String
    var code: Int
    var data: T
}

struct HTTPBinResponse: Codable { let uploadUrl: String }

struct UpdateUserMessageData: Codable {
    var name: String
    var headimage: String
}


struct NoneResponseData: Codable {
}


class NetWork {
    static var dic: [String:Any] = [:]
//    static let baseURL = "http://qiangqiang.natapp1.cc"
//    static let baseURL = "http://42.192.22.161:8020"
    static let baseURL = "https://app.jingkeys.com/app-api"
//    static let baseURL = "http://42.97.46.183:7100/phoneRepair-app"
    
    static func request<T: Codable>(_ endpoint: EndPoint,
                        method: HTTPMethod = .post,
                        modelType: T.Type,
                        parameters: [String: Any] = [:],
                        successBlock: @escaping (_ result: HTTPResultType, _ model: T?, _ msg:String) -> Void) {
        
        if case .getSys = endpoint, let category = parameters["category"] as? String, let data = dic[category] as? T {
            successBlock(.success, data, "")
            return
        }
        if (endpoint.rawValue.contains("/private/") && !isLogin()) {
            return
        }
        
        var encoding:ParameterEncoding = URLEncoding.default
        if method == .post {
            encoding = JSONEncoding.default
        }
        
        let url = Self.baseURL + endpoint.rawValue
        
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoding: encoding,
                   headers: Self.headers()).responseDecodable(of:ResponseData<T>.self, decoder: CleanJSONDecoder()) { (data) in
            if let data = data.data {
                print(NSString(data:data ,encoding: String.Encoding.utf8.rawValue) ?? "")
            }
            
            if let value = data.value {
                if value.code == 200 {
                    if case .getSys = endpoint, let category = parameters["category"] as? String {
                        dic[category] = value.data
                    }
                    successBlock(.success, value.data, "")
                } else {
                    if value.code == 401 {
                        UserDefaults.standard.set("", forKey: "gToken")
                        gToken = nil
                        return
                    }
                    successBlock(.failure, nil, value.msg)
                    if !value.msg.isEmpty {
                        Toast(text: value.msg, duration: 0.5).show()
                    } else {
                        Toast(text: "服务器出错", duration: 0.5).show()
                    }
                }
            } else {
                successBlock(.failure, nil, "")
            }
        }
    }
    
    static func upload<T: Codable>(_ data: Data,
                                   name:String,
                                   modelType: T.Type,
                                   successBlock: @escaping (_ result: HTTPResultType, _ model: T?, _ msg:String) -> Void) {
        let url = Self.baseURL + EndPoint.uploadImage.rawValue

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "file", fileName: name, mimeType: "image/png")
        }, to: url).responseDecodable(of: ResponseData<T>.self) { data in
            if let value = data.value {
                if value.code == 200 {
                    successBlock(.success, value.data, "")
                } else {
                    successBlock(.failure, nil, value.msg)
                    if !value.msg.isEmpty {
                        Toast(text: value.msg, duration: 0.5).show()
                    }
                }
            } else {
                successBlock(.failure, nil, "")
            }
        }
    }
    
    static func headers() -> HTTPHeaders? {
        if let token = gToken, !token.isEmpty {
            let header = HTTPHeader.init(name: "Authorization", value: token)
//            let header = HTTPHeader.init(name: "Authorization", value: "eyJhbGciOiJIUzUxMiJ9.eyJsb2dpbl91c2VyX2tleSI6IjQ3ODhmYjE3LTRmN2EtNDZhOC1iYWRmLTdiY2VkZDdjMmM5NCJ9.um5KcNbs9ftDTBgCNjYo33wqfZZ34R3HDO9wcLJ1QBY_trElAtQ5YKuQwKy9h2NOfuPWNR_ZN03PUAGtTktY8w")
            return HTTPHeaders.init([header])
        }
        return nil
    }
}
