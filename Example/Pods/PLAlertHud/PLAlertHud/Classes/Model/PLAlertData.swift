//
//  PLAlertData.swift
//  PLAlertHud
//
//  Created by za on 2020/9/8.
//

import UIKit
 
public class PLAlertData: NSObject {
    
    var title: String?
    public var titelAttributeString: NSAttributedString?
    var message: String?
    public var messageAttributeString: NSAttributedString?
    
    var actions: [PLAlertAction] = []
    var cancelAction: PLAlertAction?
    lazy var otherActions: Array<PLAlertAction> = {
        return self.actions.filter {
            $0.style != .Cancel
        }
    }()
    
    public init(title: String? = nil, message: String? = nil, cancelTitle: String? = nil, otherTitles: Array<String>? = nil) {
       
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .center
                
        if let titleString = title {
            self.title = titleString
            self.titelAttributeString = NSAttributedString(string: titleString, attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.Text.Title,
                NSAttributedStringKey.font : UIFont.Text.Title,
                NSAttributedStringKey.paragraphStyle : style
            ])
        }
        
        if let messageString = message {
            style.lineSpacing = 3
            self.message = messageString
            self.messageAttributeString = NSAttributedString(string: messageString, attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.Text.Message,
                NSAttributedStringKey.font : UIFont.Text.Message,
                NSAttributedStringKey.paragraphStyle : style
            ])
        }
        
        if let other = otherTitles {
            for (index, item) in other.enumerated() {
                self.actions.append(PLAlertAction(title: item, style: index == 0 ? .Destructive : .Default))
            }
        }
        
        if let cancel = cancelTitle {
            self.cancelAction = PLAlertAction(title: cancel, style: .Cancel)
            self.actions.count > 1 ? self.actions.append(self.cancelAction!) : self.actions.insert(self.cancelAction!, at: 0)
        }
    }
    
    //MARK: 添加自定义事件
    public func addAction(action: PLAlertAction) -> Void {
                
        if cancelAction != nil, action.style == .Cancel { return }
        if case .Cancel = action.style { cancelAction = action }
        actions.append(action)
        setActionOrder()
    }
    
    //MARK: 调整事件顺序
    func setActionOrder() {
        
        //当包含取消事件时，才需要调整顺序
        if actions.contains(where: { $0.style == .Cancel }) {
            
            if actions.count > 2 {//当事件个数大于2个，且最后一个不是取消事件时，把取消事件放在最后
                if actions.last?.style != cancelAction?.style {
                    actions.removeAll(where: { $0.style == .Cancel})
                    actions.append(self.cancelAction!)
                }
            } else {//当事件个数不大于2个，且第一个不是取消事件时，把取消事件放在第一个
                if actions.first?.style != cancelAction?.style {
                    actions.removeAll(where: { $0.style == .Cancel})
                    actions.insert(self.cancelAction!, at: 0)
                }
            }
        }
    }
    
}
