////
////  PLActionSheetView.swift
////  PLAlertHud
////
////  Created by za on 2020/9/8.
////

import UIKit

class PLActionSheetView: UIView, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: PLAlertHudDelegate?
    var textTableView: UITableView?
    var actionTableView: UITableView?
    var alertData: PLAlertData?
    var cancelView: UIView?
    var topView: UIView?

    convenience init() {
        self.init(frame: CGRect.zero)
        self.setupUI()
    }

    func reloadUI(with alertData: PLAlertData) {
        self.alertData = alertData
        textTableView?.reloadData()
        createActionView()
        updateFrame()
    }

    func updateFrame() {
        
        textTableView?.layoutIfNeeded()
        
        var safeBottomEdge: CGFloat = 0
        if #available(iOS 11.0, *) { safeBottomEdge = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 }
        var y: CGFloat = 0
        let otherCount: Int = alertData?.otherActions.count ?? 0
        let cancelViewHeight: CGFloat = alertData?.cancelAction != nil ? (CGFloat.Alert.ActionSheetMargin*2 + CGFloat.Alert.ActionHeight) : 0

        if  textCount() == 0 {
            textTableView?.removeFromSuperview()
        } else {
            let textContentHeight = textTableView?.contentSize.height ?? 0
            let actionHeight: CGFloat = (otherCount>2 ? 2.5 : CGFloat(otherCount))*CGFloat.Alert.ActionHeight + cancelViewHeight
            
            let textTableHeight: CGFloat = min(CGFloat.ScreenHeight-CGFloat.Alert.ActionSheetTopMargin-actionHeight-CGFloat.Alert.TitleTopMargin*2-safeBottomEdge, textContentHeight)
            
            textTableView?.bounces = textTableHeight != textContentHeight
            textTableView?.showsVerticalScrollIndicator = textTableHeight != textContentHeight
            textTableView?.frame = CGRect(origin: CGPoint(x: 0, y: CGFloat.Alert.TitleTopMargin), size: CGSize(width: CGFloat.Alert.ActionSheetContentWidth, height: textTableHeight))
            y += (textTableHeight + CGFloat.Alert.TitleTopMargin*2)
        }
        
        if otherCount > 0 {
            
            if textCount() > 0 {
                let line: CALayer = CALayer()
                line.backgroundColor = UIColor.SeparatorColor.cgColor
                line.frame = CGRect(x: 0, y: y, width: CGFloat.Alert.ActionSheetContentWidth, height: CGFloat.Alert.SeparatorHeight)
                topView?.layer.insertSublayer(line, above: actionTableView?.layer)
            }
            
            let actionTableContentHeight: CGFloat = CGFloat.Alert.ActionHeight*CGFloat(otherCount)
            let actionTableHeight: CGFloat = min(CGFloat.ScreenHeight-CGFloat.Alert.ActionSheetTopMargin-y-safeBottomEdge-cancelViewHeight, actionTableContentHeight)
            actionTableView?.bounces = actionTableHeight != actionTableContentHeight
            actionTableView?.showsVerticalScrollIndicator = actionTableHeight != actionTableContentHeight
            actionTableView?.frame = CGRect(x: 0, y: y, width: CGFloat.Alert.ActionSheetContentWidth, height: actionTableHeight)
            y += actionTableHeight
        }
        
        
        if  y == 0 {
            topView?.removeFromSuperview()
        } else {
            topView?.frame = CGRect(x: 0, y: 0, width: CGFloat.Alert.ActionSheetContentWidth, height: y)
        }
        
        if let _ = alertData?.cancelAction {
            cancelView?.frame = CGRect(x: 0, y: y, width: CGFloat.Alert.ActionSheetContentWidth, height: cancelViewHeight)
            y += cancelViewHeight
        }
        
        y += safeBottomEdge
        
        frame = CGRect(x: CGFloat.Alert.ActionSheetMargin, y: CGFloat.ScreenHeight-y, width: CGFloat.Alert.ActionSheetContentWidth, height: y)
    }

    func createActionView() {
        
        let actionCount: Int = alertData?.actions.count ?? 0
        
        if actionCount > 0 {
            
            if let cancelAction = alertData?.cancelAction {
                
                cancelView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.Alert.ActionSheetContentWidth, height: CGFloat.Alert.ActionHeight + CGFloat.Alert.ActionSheetMargin*2))
                cancelView?.backgroundColor = UIColor.clear
                
                let cancelButton: UIButton = PLAlertView.createButton(width: CGFloat.Alert.ActionSheetContentWidth, action: cancelAction)
                cancelButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
                cancelButton.frame = CGRect(x: 0, y: CGFloat.Alert.ActionSheetMargin, width: CGFloat.Alert.ActionSheetContentWidth, height: CGFloat.Alert.ActionHeight)
                cancelButton.layer.cornerRadius = CGFloat.Alert.CornerRadius
                cancelButton.layer.masksToBounds = true
                cancelButton.backgroundColor = UIColor.Backgroud.Alert
                cancelView?.addSubview(cancelButton)
                    
                addSubview(cancelView!)
            }
            
            if let _ = alertData?.otherActions {
                actionTableView = PLAlertView.createTableView(delegate: self)
                actionTableView?.rowHeight = CGFloat.Alert.ActionHeight
                topView?.addSubview(actionTableView!)
            }
        }
    }

    func setupUI() {

        backgroundColor = UIColor.clear
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.Alert.ActionSheetContentWidth, height: CGFloat.Alert.TitleTopMargin*2))
        topView?.backgroundColor = UIColor.Backgroud.Alert
        topView?.layer.cornerRadius = CGFloat.Alert.CornerRadius
        topView?.layer.masksToBounds = true
        addSubview(topView!)
        
        textTableView = PLAlertView.createTableView(delegate: self)
        textTableView?.frame = topView?.bounds ?? CGRect.zero
        textTableView?.rowHeight = UITableViewAutomaticDimension
        textTableView?.backgroundColor = UIColor.clear
        topView?.addSubview(textTableView!)
    }
    
    //MARK: 点击按钮
    @objc
    func buttonClick(button: UIButton) {
        self.delegate?.alertActionDidClick(action: button.currentTitle)
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == actionTableView ? alertData?.otherActions.count : textCount()) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == actionTableView {
            let textCell: PLTextCell = self.textCell(with: .Action, action: alertData?.otherActions[indexPath.row])
            textCell.line.isHidden = indexPath.row == alertData!.otherActions.count-1
            return textCell
        } else {
            
            if indexPath.row == 0 && (alertData?.title != nil || alertData?.titelAttributeString != nil) {
                return textCell(with: .Title)
            }
            return textCell(with: .Message)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == actionTableView {
            let textCell: PLTextCell = tableView.cellForRow(at: indexPath) as! PLTextCell
            self.delegate?.alertActionDidClick(action: textCell.contentLabel.text)
        }
    }
    
    func textCell(with type: PLTextCellType, action: PLAlertAction? = nil) -> PLTextCell {
        
        let tableView: UITableView = (type == .Action ? actionTableView : textTableView)!
        let textCell: PLTextCell = tableView.dequeueReusableCell(withIdentifier: String(describing: PLTextCell.self)) as! PLTextCell
        textCell.setType(type: type)
        
        if let alertAction = action {
            textCell.contentLabel.text = alertAction.title
            textCell.contentLabel.textColor = alertAction.titleColor
            textCell.contentLabel.font = alertAction.titleFont
        } else {
            if case .Title = type {
                if let attributeString = alertData?.titelAttributeString {
                    textCell.contentLabel.attributedText = attributeString
                }
            } else {
                
                if alertData?.title != nil || alertData?.titelAttributeString != nil {
                    textCell.labelTopMargin.constant = CGFloat.Alert.MessageTopMargin
                }
                
                if let attributeString = alertData?.messageAttributeString {
                    textCell.contentLabel.attributedText = attributeString
                }
            }
        }
        
        return textCell
    }
    
    func textCount() -> Int {
        var count: Int = 0
        
        if alertData?.title != nil || alertData?.titelAttributeString != nil {
            count += 1
        }
        
        if alertData?.message != nil || alertData?.messageAttributeString != nil {
            count += 1
        }
        return count
    }
    
    
}
