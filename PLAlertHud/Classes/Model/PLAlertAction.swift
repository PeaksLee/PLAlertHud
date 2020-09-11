//
//  PLAlertAction.swift
//  PLAlertHud
//
//  Created by za on 2020/9/8.
//

import UIKit

public enum PLActionStyle: Int {
    case Default = 0, Cancel, Destructive
}

public struct PLAlertAction {
    
    var title: String
    var titleColor: UIColor
    var titleFont: UIFont
    var style: PLActionStyle
    
    init(title: String, style: PLActionStyle, color: UIColor? = nil, font: UIFont? = nil)  {
        
        self.title = title
        self.style = style
        
        switch style {
        case .Cancel:
            self.titleColor = UIColor.Action.Cancel
            self.titleFont = UIFont.Action.Cancel
        case .Destructive:
            self.titleColor = UIColor.Action.Destructive
            self.titleFont = UIFont.Action.Destructive
        default:
            self.titleColor = UIColor.Action.Default
            self.titleFont = UIFont.Action.Default
        }
        
        if let titleColor = color {
            self.titleColor = titleColor
        }
        
        if let titleFont = font {
            self.titleFont = titleFont
        }
    }
    
    
    static public func action(title: String, style: PLActionStyle) -> PLAlertAction {
        
        return PLAlertAction(title: title, style: style)
    }
    
    //MARK: 自定义事件样式
    static public func action(title: String, style: PLActionStyle, color: UIColor, font: UIFont) -> PLAlertAction {
        
        return PLAlertAction(title: title, style: style, color: color, font: font)
    }
    
    //MARK: 生成纯色图片
    static func highlightedImage(color: UIColor, size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.SeparatorColor.cgColor)
        context?.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? nil
        UIGraphicsEndImageContext()
        return image
    }
}
