//
//  AppDelegate.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/19.
//

import UIKit

let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

// 判断是否为 iPhone X
let isIphoneX = kScreenH >= 812 ? true : false
// 状态栏高度
let kStatuHeight : CGFloat = isIphoneX ? 44 : 20
// 导航栏高度
let kNavigationBarHeight :CGFloat = 44+kStatuHeight

// TabBar高度
let kTabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49

// 宽度比
let kWidthRatio = kScreenW / 375.0
// 高度比
let kHeightRatio = kScreenH / 667.0

let kBannerRatio = 1080.0 / 450.0

let kUnit = "R$ "
let kAmountUnit = " itens"

let kMainColor1 = "#FE8328"
let kMainColor2 = "#333333"
let kMainColor3 = "#999999"
let kSubColor1 = "#ff4038"
let kSubColor2 = "#666666"
let kSubColor3 = "#EAEAEB"
let kSubColor4 = "#f7f7f7"

let kThemeColor = "#865B2E"

//个人中心头部高度
let personRate:CGFloat = 750.0/291.0
let kPersonHeaderImgViewHeight:CGFloat = kScreenW/personRate
let kPersonHeaderHeight:CGFloat = kPersonHeaderImgViewHeight + 115

//导航栏的标题大小
let kNavBarTitleFontSize = 19.0

//定义通用闭包
typealias WZC_CommonBlock = (_ value:Any)->Void

//获取图片
func IMAGE(_ name:String) -> UIImage {
    
    return UIImage(named: name) ?? UIImage(named: "icon_empty")!
}

//颜色
func HEX(_ code:String, alpha: CGFloat = 1.0) -> UIColor {
    var hex = code
    var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
    if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
        hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
    } else if hex.hasPrefix("#") {
        hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
    }
    if hex.count < 6 {
        for _ in 0..<6-hex.count {
            hex += "0"
        }
    }
    Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
    Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
    Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)...])).scanHexInt64(&blue)

    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
}

//字体大小
func FONT(size:CGFloat) -> UIFont {
    
    return UIFont.systemFont(ofSize: size)
}


// 自适应
func Adapt(_ value : CGFloat) -> CGFloat {
    
    return AdaptW(value)
}

// 自适应宽度
func AdaptW(_ value : CGFloat) -> CGFloat {
    
    return ceil(value) * kWidthRatio
}

// 自适应高度
func AdaptH(_ value : CGFloat) -> CGFloat {
    
    return ceil(value) * kHeightRatio
}

//颜色渐变
func zc_setUpGradientLayer(view : UIView , frame : CGRect , color : [CGColor], corneradiu : CGFloat? = 0){
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    gradientLayer.colors = color
    //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
    //渲染的起始位置
    gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
    //渲染的终止位置
    gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
    //设置frame和插入view的layer
    gradientLayer.frame = frame
    gradientLayer.cornerRadius = corneradiu!
    view.layer.insertSublayer(gradientLayer, at: 0)
}

let kMainNavBarBackGroundColor = UIColor(red: colorValueToFloat(204), green: colorValueToFloat(2), blue: colorValueToFloat(2), alpha: 1);

let kMainNavBarTitleColor = UIColor.init(red: colorValueToFloat(255), green: colorValueToFloat(255), blue: colorValueToFloat(255), alpha: 1)

let kMainTitleColor_51 = UIColor.init(red: colorValueToFloat(51), green: colorValueToFloat(51), blue: colorValueToFloat(51), alpha: 1);


func colorValueToFloat(_ value:CGFloat)->CGFloat{
    
    return value/255.0
}


public func RGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    
    return UIColor(red: colorValueToFloat(r), green: colorValueToFloat(g), blue: colorValueToFloat(b), alpha: 1)
}


public func rgba(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->UIColor{
    
    return UIColor(red: colorValueToFloat(r), green: colorValueToFloat(g), blue: colorValueToFloat(b), alpha: a)
}

// 常规字体
func Font(_ size : CGFloat) -> UIFont {
    
    return UIFont.systemFont(ofSize: AdaptW(size))
}

// 加粗字体
func BFont(_ size : CGFloat) -> UIFont {
    
    return UIFont.boldSystemFont(ofSize: AdaptW(size))
}

