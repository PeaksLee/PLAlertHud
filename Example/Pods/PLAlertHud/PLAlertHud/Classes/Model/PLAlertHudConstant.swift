//
//  PLAlertHudConstant.swift
//  PLAlertHud
//
//  Created by za on 2020/9/8.
//

import Foundation

extension CGFloat {
    
    static let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    static let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    struct Alert {
        static let Width: CGFloat = CGFloat.ScreenWidth >= 375 ? 300 : 270
        static let CornerRadius: CGFloat = 9.0
        static let ActionHeight: CGFloat = 45.0
        static let TitleTopMargin: CGFloat = 20.0
        static let MessageTopMargin: CGFloat = 10.0
        static let TextHorizontalMargin: CGFloat = 24
        static let ActionHorizontalMargin: CGFloat = 12
        static let SeparatorHeight: CGFloat = (1/UIScreen.main.scale)
        static let AlertVerticalMargin: CGFloat = 60
        static let coverAlpha: CGFloat = 0.7
        
        static let ActionSheetMargin: CGFloat = 8.0
        static let ActionSheetContentWidth: CGFloat = (CGFloat.ScreenWidth - CGFloat.Alert.ActionSheetMargin*2)
        static let ActionSheetTopMargin: CGFloat = 60
    }
}

extension UIFont {
    
    struct Text {
        /// 标题颜色
        static let Title: UIFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        /// 信息颜色
        static let Message: UIFont = UIFont.systemFont(ofSize: 15)
    }
    
    struct Action {
        /// 取消操作颜色
        static let Cancel: UIFont = UIFont.systemFont(ofSize: 17)
        /// 默认操作颜色
        static let Default: UIFont = UIFont.systemFont(ofSize: 17)
        /// 破坏性颜色
        static let Destructive: UIFont = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
}

extension UIColor {
    
    /// 分割线颜色
    static let SeparatorColor: UIColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    
    struct Backgroud {
        /// 蒙层背景颜色
        static let Cover: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        /// 弹窗背景颜色
        static let Alert: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    struct Text {
        /// 标题颜色
        static let Title: UIColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        /// 信息颜色
        static let Message: UIColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
    }
    
    struct Action {
        /// 取消操作颜色
        static let Cancel: UIColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        /// 默认操作颜色
        static let Default: UIColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        /// 破坏性颜色
        static let Destructive: UIColor = #colorLiteral(red: 0.1490196078, green: 0.431372549, blue: 1, alpha: 1)
    }
}
