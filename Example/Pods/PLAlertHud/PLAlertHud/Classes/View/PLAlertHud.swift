//
//  PLAlertHud.swift
//  PLAlertHud
//
//  Created by za on 2020/9/8.
//

import UIKit

protocol PLAlertHudDelegate: NSObjectProtocol {
    func alertActionDidClick(action title: String?) -> Void
}

extension PLAlertHudDelegate {
    func alertActionDidClick(action title: String?) -> Void {}
}

public class PLAlertHud: UIView, PLAlertHudDelegate {
    
    var style: PLAlertHudStyle = .alert
    var completeHandler: CompleteHandler?
    
    var coverView: UIView?
    var coverTap: UIGestureRecognizer?
    
    var alertView: PLAlertView?
    var actionSheetView: PLActionSheetView?
    var alertData: PLAlertData?
    var autoHide: Bool = true
    
    public convenience init(style: PLAlertHudStyle, completeHandler: CompleteHandler?) {
        self.init(frame: UIScreen.main.bounds)
        self.style = style
        self.completeHandler = completeHandler
        self.setupUI()
    }
    
    public func show(with data: PLAlertData) {
        
        alertData = data
        coverTap?.isEnabled = data.actions.count == 0
        
        if case .actionSheet = style {
            actionSheetView?.reloadUI(with: data)
            
            let popAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            popAnimation.fromValue = actionSheetView?.bounds.size.height
            popAnimation.toValue = 0
            popAnimation.duration = 0.3
            popAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            actionSheetView?.layer.add(popAnimation, forKey: nil)
        } else {
            alertView?.reloadUI(with: data)
            alertView?.center = center
            
            let popAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
            popAnimation.duration = 0.6
            popAnimation.values = [NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
                                   NSValue(caTransform3D: CATransform3DIdentity)]
            popAnimation.keyTimes = [0.1, 0.5]
            popAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            alertView?.layer.add(popAnimation, forKey: nil)
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) { self.coverView?.alpha = CGFloat.Alert.coverAlpha }
    }
    
    @objc
    public func hide() {
        
        if case .actionSheet = style {
            let popAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            popAnimation.fromValue = 0
            popAnimation.toValue = actionSheetView?.bounds.size.height
            popAnimation.duration = 0.3
            popAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            actionSheetView?.layer.add(popAnimation, forKey: nil)
        } else {
            self.alertView?.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.coverView?.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    func setupUI() {
        
        backgroundColor = UIColor.clear
        
        coverView = UIView(frame: bounds)
        coverView?.backgroundColor = UIColor.Backgroud.Cover
        coverView?.alpha = 0
        addSubview(coverView!)
        
        coverTap = UITapGestureRecognizer(target: self, action: #selector(hide))
        coverView?.addGestureRecognizer(coverTap!)
        
        if case .actionSheet = style {
            
            actionSheetView = PLActionSheetView()
            actionSheetView?.delegate = self
            addSubview(actionSheetView!)
        } else {
            
            alertView = PLAlertView()
            alertView?.delegate = self
            alertView?.center = center
            addSubview(alertView!)
        }
        
    }
    
    func alertActionDidClick(action title: String?) {
        if autoHide { hide() }
        if let handler = completeHandler {
            handler(self, title == alertData?.cancelAction?.title, title ?? "")
        }
    }
}

