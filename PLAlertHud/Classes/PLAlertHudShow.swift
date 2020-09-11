//
//  PLAlertHudShow.swift
//  PLAlertHud
//
//  Created by za on 2020/9/10.
//

import Foundation

public enum PLAlertHudStyle: Int{
    case alert, actionSheet
}

public typealias CompleteHandler = (_ alert: PLAlertHud, _ isCancel: Bool, _ actionTitle: String) -> Void

public extension PLAlertHud {
    
    //MARK: 显示hud，会自动消失
    class func show(_ title: String? = nil,
             message: String? = nil,
             _ style: PLAlertHudStyle? = .alert,
             cancelTitle: String? = nil,
             _ otherTitle: [String]? = nil,
             _ complete: CompleteHandler? = nil) -> Void {
        
        let hud: PLAlertHud = PLAlertHud(style: style ?? .alert, completeHandler: complete)
        let data: PLAlertData = PLAlertData(title: title, message: message, cancelTitle: cancelTitle, otherTitles: otherTitle)
        hud.show(with: data)
    }
    
    //MARK: 显示hud，不会自动消失
    class func hud(_ title: String? = nil,
             message: String? = nil,
             _ style: PLAlertHudStyle? = .alert,
             cancelTitle: String? = nil,
             _ otherTitle: [String]? = nil,
             _ complete: CompleteHandler? = nil) -> PLAlertHud {
        
        let hud: PLAlertHud = PLAlertHud(style: style ?? .alert, completeHandler: complete)
        hud.autoHide = false
        let data: PLAlertData = PLAlertData(title: title, message: message, cancelTitle: cancelTitle, otherTitles: otherTitle)
        hud.show(with: data)
        return hud
    }
    
    
}
